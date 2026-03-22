**Terraform** works in a simple flow after you write your `.tf` files. It follows three main stages that help you safely create infrastructure.

  - First, `terraform init` prepares your project. It sets up everything needed to start, like connecting to the cloud provider (such as AWS), downloading required plugins, and configuring any backend.
    In simple terms, this step gets your environment ready before doing anything.

  - Next, `terraform plan` reads your code and shows what will happen if you proceed. It tells you which resources will be created or changed, but it does not actually create anything.
    This step acts like a preview so you can verify that your configuration is correct.

  - Finally, `terraform apply` performs the actual work. It makes API calls to the cloud provider and creates the resources defined in your code, such as VPCs, ECS clusters, and other components.

Overall, Terraform first prepares the environment, then shows you a preview of changes, and finally executes those changes to build your infrastructure.
