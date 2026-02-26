output "policy_ids" {
  description = "Map of policy names to IDs"
  value       = { for k, v in aws_organizations_policy.scps : k => v.id }
}
