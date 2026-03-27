output "s3_bucket_name" {
  value       = opentel-terraform-state-eks-bucket.id
  description = "The name of the S3 bucket"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_locks.id
  description = "The name of the DynamoDB table"
}
