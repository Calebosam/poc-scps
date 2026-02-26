#!/bin/bash
set -e

BUCKET_NAME="${1:-terraform-state-scps-a1b2c44}"
TABLE_NAME="${2:-terraform-state-lock-scps}"
REGION="${3:-us-east-1}"

echo "Creating S3 bucket: $BUCKET_NAME"
if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
  echo "Bucket already exists, skipping creation"
else
  aws s3api create-bucket --bucket "$BUCKET_NAME" --region "$REGION"
  echo "Enabling versioning on S3 bucket"
  aws s3api put-bucket-versioning --bucket "$BUCKET_NAME" --versioning-configuration Status=Enabled
  echo "Enabling encryption on S3 bucket"
  aws s3api put-bucket-encryption --bucket "$BUCKET_NAME" --server-side-encryption-configuration '{
    "Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]
  }'
fi

echo "Creating DynamoDB table: $TABLE_NAME"
if aws dynamodb describe-table --table-name "$TABLE_NAME" --region "$REGION" 2>/dev/null; then
  echo "Table already exists, skipping creation"
else
  aws dynamodb create-table \
    --table-name "$TABLE_NAME" \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region "$REGION"
  echo "Waiting for table to be active..."
  aws dynamodb wait table-exists --table-name "$TABLE_NAME" --region "$REGION"
fi

echo "Backend resources created successfully!"
echo "Bucket: $BUCKET_NAME"
echo "Table: $TABLE_NAME"
