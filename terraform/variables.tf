variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "policy_attachments" {
  description = "Map of policy attachments to OUs or accounts"
  type = map(object({
    policy_file = string
    target_id   = string
  }))
}
