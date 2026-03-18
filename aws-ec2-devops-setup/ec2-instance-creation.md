# AWS EC2 Instance Setup
## Introduction

Amazon EC2 (Elastic Compute Cloud) allows you to run scalable virtual servers in the cloud.

## Step-by-Step EC2 Instance Setup

**Step 1: Sign in to AWS Console**

  - Go to the AWS Management Console
  - Log in using your AWS account credentials
  - Navigate to the EC2 Dashboard

**Step 2: Launch a New EC2 Instance**

  - Click on Launch Instance
  - Enter a name for your instance

**Step 3: Select an Amazon Machine Image (AMI)**

  - Choose an operating system (OS)
  - Click Select

**Step 4: Choose an Instance Type**

  - Select an appropriate instance type:
  - t3.xlarge or higher (for heavier workloads)
  - Click Next

**Step 5: Configure Instance Settings**

  - Use the default VPC and Subnet (unless you need custom networking)
  - Enable Auto-assign Public IP to allow internet access
  - Click Next

**Step 6: Configure Storage**

  - Default storage is 8 GB, but you can increase it to 30 GB if needed (e.g., for storing container images or project files)
  - Click Next

**Step 7: Set Up Security Group**

  - Create a new security group or choose an existing one
  - Allow SSH (Port 22) for Linux instances

**Step 8: Create or Select a Key Pair**

  - Choose Create a new key pair
  - Select RSA format and download the .pem file
  - Store the key securely
  - Click Launch Instance

**Step 9: Connect to Your EC2 Instance**

  - Go to EC2 Dashboard → Instances
  - Select your instance and click `Connect`

**For Linux Instances:**

Connect using SSH from your terminal:

```bash
ssh -i /path/to/your-key.pem ec2-user@your-instance-public-ip
```
You can also use `putty` to ssh in to the ec-2 instance.
