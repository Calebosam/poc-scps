#!/bin/bash
set -e

BUCKET_NAME="${1:-terraform-state-scps-a1b2c44}"
TABLE_NAME="${2:-terraform-state-lock-scps}"
REGION="${3:-us-east-1}"

echo "Emptying S3 bucket: $BUCKET_NAME"
aws s3 rm "s3://$BUCKET_NAME" --recursive 2>/dev/null || echo "Bucket already empty or doesn't exist"

echo "Deleting S3 bucket: $BUCKET_NAME"
aws s3api delete-bucket --bucket "$BUCKET_NAME" --region "$REGION" 2>/dev/null || echo "Bucket doesn't exist"

echo "Deleting DynamoDB table: $TABLE_NAME"
aws dynamodb delete-table --table-name "$TABLE_NAME" --region "$REGION" 2>/dev/null || echo "Table doesn't exist"

echo "Backend resources destroyed successfully!"
