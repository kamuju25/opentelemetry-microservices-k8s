# Why Infrastructure as Code (IaC)?

Earlier, people created AWS resources (like EC2, VPC) manually using the UI. This works for small tasks, but if you need to create hundreds or thousands of resources, it becomes:
  - Time-consuming
  - Repetitive
  - Error-prone

**Example:**

  1. Creating one VPC manually → approx. 1 hour
     100 requests → 100 hours wasted  

## What is Infrastructure as Code?

IaC means writing infrastructure (servers, networks, clusters) as code.
Instead of clicking buttons, you:  
  - Write code once
  - Run it multiple times
  - Get consistent results every time

## Why Terraform is Popular?

Each cloud has its own tool:
  - AWS → CloudFormation
  - Azure → ARM / Bicep
  - GCP → Deployment Manager

The Problem is to learn different tools for each cloud. For that reason, Terraform is widely used as it works with AWS, Azure, GCP or any other cloud provider. Only small changes are needed, such as differences in resource names between cloud providers.

Here in this project using **Terraform** all the below components are created -

  - VPC (Virtual Private Cloud)
  - All its components (subnets, routes, gateway)
  - ECS cluster inside the VPC
