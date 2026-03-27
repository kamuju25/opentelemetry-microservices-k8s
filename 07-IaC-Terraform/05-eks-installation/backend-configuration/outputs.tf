output "s3_bucket_name" {
  value       = opentel-terraform-state-eks-bucket.id
  description = "The name of the S3 bucket"
}

output "dynamodb_table_name" {
  value       = opentel-terraform-state-eks-lock.id
  description = "The name of the DynamoDB table"
}
