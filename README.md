# AWS SCP GitOps PoC

Automated AWS Service Control Policy management with GitHub versioning.

## Setup

1. Configure AWS credentials with Organizations access
2. Update `terraform/terraform.tfvars` with your Organization details
3. Configure GitHub OIDC (see `.github/workflows/deploy.yml`)
4. Push to `main` branch to deploy

## Structure

- `policies/` - SCP JSON files
- `terraform/` - Infrastructure as Code
- `.github/workflows/` - CI/CD automation
# poc-scps
