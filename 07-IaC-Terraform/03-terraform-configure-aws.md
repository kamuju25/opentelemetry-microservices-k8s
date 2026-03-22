Terraform needs permission to talk to AWS before it can create any resources. To give permission, you must provide your AWS credentials (Access Key and Secret Key).

  - First, log in to your AWS account using an IAM user (recommended) or root user.
  - Go to Security Credentials and create Access Keys for CLI usage.

<img width="927" height="740" alt="image" src="https://github.com/user-attachments/assets/c4900f19-5659-44f5-baa9-177170cf2074" />

  - Save these keys safely because they are very sensitive.
  - Next, install the `AWS CLI` on your local machine.
  - After installation, run the command aws configure.

    Enter your:
      - Access Key
      - Secret Key
      - Region (like us-east-1)

  - Once configured, AWS CLI creates a hidden folder called `.aws` on your system.
  - Inside this folder, there is a credentials file that stores your keys.
  - Terraform automatically reads this credentials file.
  - Using these credentials, Terraform can make API calls to AWS.
  - Then Terraform can create resources like VPC, ECS, etc.
