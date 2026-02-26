aws_region = "us-east-1"

policy_attachments = {
  "deny_regions_prod_ou" = {
    policy_file = "deny-unapproved-regions.json"
    target_id   = "ou-fbmz-52msea3o"  # Replace with your OU ID
  }
  "require_mfa_dev_ou" = {
    policy_file = "require-mfa.json"
    target_id   = "ou-fbmz-52msea3o"  # Replace with your OU ID
  }
}
