terraform {
  backend "s3" {
    bucket         = "terraform-state-scps-a1b2c44"
    key            = "scps/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock-scps"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_organizations_policy" "scps" {
  for_each = fileset("${path.module}/../policies", "*.json")

  name        = replace(each.value, ".json", "")
  description = "Managed by Terraform - FinOps Team"
  content     = file("${path.module}/../policies/${each.value}")
  type        = "SERVICE_CONTROL_POLICY"
}

resource "aws_organizations_policy_attachment" "attachments" {
  for_each = var.policy_attachments

  policy_id = aws_organizations_policy.scps[each.value.policy_file].id
  target_id = each.value.target_id
}
