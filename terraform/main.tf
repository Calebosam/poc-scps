terraform {
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
  description = "Managed by Terraform"
  content     = file("${path.module}/../policies/${each.value}")
  type        = "SERVICE_CONTROL_POLICY"
}

resource "aws_organizations_policy_attachment" "attachments" {
  for_each = var.policy_attachments

  policy_id = aws_organizations_policy.scps[each.value.policy_file].id
  target_id = each.value.target_id
}
