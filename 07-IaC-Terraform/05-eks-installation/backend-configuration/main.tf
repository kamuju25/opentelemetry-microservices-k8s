provider "aws" {
    region = "us-east-1"
}

resource "aws_s3_bucket" "opentel-eks" {
  bucket = "opentel-terraform-state-eks-bucket"

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_versioning" "opentel-eks" {
  bucket = aws_s3_bucket.opentel-eks.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "opentel-eks" {
  bucket = aws_s3_bucket.opentel-eks.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "opentel-terraform-state-eks-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
