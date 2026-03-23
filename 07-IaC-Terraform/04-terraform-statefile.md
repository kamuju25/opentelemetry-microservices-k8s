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

## Terraform state file management

Terraform stores everything it creates in a state file, which is saved locally on the machine that ran Terraform. If another team member downloads the same Terraform code from Git and runs it, Terraform will try to create resources again, because the new machine doesn't have the state file (Terraform memory). We also cannot push the state file to Git because it contains sensitive data like IP addresses, infrastructure details, etc. Therefore, we must manage the state file properly using `Remote Backend` and `State Locking`, which are Terraform best practices.

## Remote backend using S3 bucket

A remote backend solves the problem of Terraform state file being stored only on one person’s machine. Instead of saving the state file locally, Terraform stores it in a shared remote location (commonly an AWS S3 bucket). When multiple team members run Terraform, they all read and update the same centralized state file, so Terraform knows what resources already exist and only applies changes. This allows safe collaboration and avoids duplicate resource creation.

The remote backend configuration can be placed either in the main.tf file or in a separate .tf file such as backend.tf.

## Terraform state file locking

Even when using a remote backend (S3), multiple team members can still run `terraform apply` at the same time. This creates a `race condition`, where both users try to update the same infrastructure simultaneously, causing conflicts. State locking solves this by locking the state file when one person runs Terraform. While locked, others must wait. On AWS, this locking is commonly implemented using `DynamoDB`, ensuring only one Terraform execution runs at a time.

### If a race condition occurs, you face three primary risks:

  - `Ghost Resources`: Resources exist in your cloud provider but are missing from your state file. You can no longer manage or delete them via Terraform.
  - `Duplicate Resources`: Terraform might try to create the same resource twice, leading to "Resource Already Exists" errors and failing builds.
  - `Partial Updates`: If one process crashes because another modified the state mid-run, your infrastructure might end up in a "half-baked" state that is difficult to roll back.

