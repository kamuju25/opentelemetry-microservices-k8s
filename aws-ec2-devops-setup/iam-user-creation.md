# AWS IAM User Creation

## Step-by-Step IAM User Setup

**Step 1: Sign in to AWS Console**

  - Go to the AWS Management Console [AWS-Console](https://console.aws.amazon.com/)
  - Log in using your Root Account
  - Navigate to the IAM Dashboard

**Step 2: Open the Users Section**

  - Click on Users in the left navigation menu
  - Select Add User

**Step 3: Enter User Information**

  - Provide a User Name (for example: opentelemetry-user)
  - Choose the AWS Credential Type:
  - Access Key (Programmatic Access): for CLI, SDKs, and API usage
  - Password (Console Access): for AWS Management Console login
  - Click Next

**Step 4: Set Permissions**

  - Select how you want to assign permissions:
  - Attach existing policies directly (e.g., AdministratorAccess, PowerUserAccess, ReadOnlyAccess)
  - Add the user to a group (recommended for easier management)
  - Copy permissions from another user
  - Click Next

**Step 5: Add Tags (Optional)**

  - Add metadata such as:
  - Department: DevOps
  - Project: E-Commerce
  - Click Next

**Step 6: Review and Create the User**

  - Verify all the details carefully
  - Click Create User

**Step 7: Save User Credentials**

  - Download the Access Key ID and Secret Access Key (if programmatic access is enabled)
  - Store these credentials securely, as they will not be shown again
  - Click Close
