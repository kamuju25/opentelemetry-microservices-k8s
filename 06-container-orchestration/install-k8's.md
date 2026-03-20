There are mainly three ways to get started with installation of Kubernetes:

## 1. Local Kubernetes (For Learning & Development)

You can run Kubernetes locally using tools like:

  - Minikube
  - Kind
  - K3s / K3d
  - MicroK8s

These are useful for:

  - Learning Kubernetes
  - Testing applications locally
  - But they are not used in production because you have to manage everything yourself (scaling, upgrades, etc.).

## 2. Self-Managed Kubernetes (Manual Setup)

You can create multiple virtual machines (for example, EC2 instances) and install Kubernetes using tools like `kubeadm`.

In this approach:

  - You manage the control plane and worker nodes
  - You handle upgrades, scaling, networking, and security

This gives full control but comes with high operational effort and complexity.

## 3. Managed Kubernetes (Most Preferred)

Cloud providers offer managed Kubernetes services like:

  - AWS --> EKS (Elastic Kubernetes Service)
  - Azure --> AKS
  - Google --> GKE

This is the most commonly used approach because:

  - Cloud provider manages the control plane
  - Easy upgrades between Kubernetes versions
  - Built-in scaling (add/remove nodes easily)
  - High availability and reliability
  - Integrated UI and monitoring
  - Better cost optimization

Why Choose Managed Kubernetes?

Managed Kubernetes is preferred because it reduces operational overhead. Instead of managing the cluster, we can focus on deploying and scaling applications while the cloud provider handles infrastructure, upgrades, and availability.

Kubernetes clusters can be created manually or by using automation tools like Terraform.

Terraform helps us:

  - Automate cluster creation (like EKS)
  - Maintain consistency
  - Follow best practices like remote backend and state locking
