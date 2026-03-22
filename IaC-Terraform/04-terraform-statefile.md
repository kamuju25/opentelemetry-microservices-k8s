# Terraform state file

Terraform’s state file is like Terraform’s memory. When you write a Terraform file (like main.tf) and run terraform apply, Terraform creates resources (for example, an AWS S3 bucket). 
At the same time, it saves all details about those resources in a state file (terraform.tfstate) — such as resource name, region, and configuration. 
Later, when you modify the Terraform code and run terraform apply again, Terraform doesn’t recreate everything. Instead, it compares the current code with the state file, finds the difference, and only updates what changed. 
If you delete a resource from your code, Terraform removes it in AWS and also deletes its entry from the state file. This is why the state file is called the heart of Terraform, because it tracks everything Terraform created and helps manage updates safely.

## Example

```bash
main.tf to create an S3 bucket:
resource "aws_s3_bucket" "demo" {
  bucket = "my-demo-bucket"
}
```
Run:
`terraform apply`

  - S3 bucket is created
  - Terraform saves details in state file

After 2 days, code is updated:
```bash
resource "aws_s3_bucket" "demo" {
  bucket = "my-demo-bucket"

  versioning {
    enabled = true
  }
}
```
Run:
`terraform apply`

Terraform will:

  - NOT create new bucket
  - Only enable versioning
  - Update state file
