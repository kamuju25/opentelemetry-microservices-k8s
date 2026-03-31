## Connect to EKS cluster

To access an EKS cluster from an EC2 instance using kubectl, kubectl depends on a kubeconfig file, which stores information about clusters, users, and contexts. By default, kubectl does not know which cluster to connect to, so commands like   
`kubectl get nodes`

will return nothing. The kubeconfig file can contain multiple clusters, and a context determines which cluster kubectl is currently connected to. You can view this configuration using `kubectl config view`

check the active context with `kubectl config current-context`, and switch contexts using `kubectl config use-context <clustername>`

To connect EC2 instance to an EKS cluster, it is required to install the AWS CLI (along with unzip), then run `aws configure` and provide your IAM user credentials. After configuration, use the command   

`aws eks update-kubeconfig --name <cluster-name> --region <region>`  

to automatically add the EKS cluster details to the kubeconfig file and set the context. Once this is done, running kubectl get nodes will show the nodes of your EKS cluster, confirming that your EC2 instance is successfully connected.

## Deploying OpenTelemetry Project on the EKS Cluster

First, go back to your EC2 instance and perform some quick checks. Verify that you are connected to the correct cluster (Minikube, EKS, or any other). This command helps confirm the current cluster.

```bash
kubectl config current-context
```
Second, verify that no old resources exist:

```bash
kubectl get all
```
Make sure there are no deployments or services. If this project was run previously, ensure everything is deleted. Also check whether resources were created in another namespace.

Next, navigate to the **opentel** project directory and then to the **Kubernetes** folder.

The first resource we need to create is the service account using **svcaccount.yaml**, which mainly contains the service account name and labels. This service account will be used in all Kubernetes manifests.

Apply it using:

```bash
kubectl apply -f svcaccount.yaml
```
Verify:

```bash
kubectl get sa
```
Now, all microservices can be deployed. You can apply each folder individually, but that takes time. Instead, use **opentel-deployment.yaml**, which merges all deployment and service files for all microservices.

Deploy everything using:

```bash
kubectl apply -f opentel-deployment.yaml
```
This will create services first and then deployments.

Verify pods:

```bash
kubectl get pods
```
Wait until all pods are in the Running state.

Then verify services:

```bash
kubectl get svc
```
Once everything is running, all microservices are connected using service names and environment variables. This is Kubernetes service discovery. 
However, the application is still not accessible externally because the service type is ClusterIP, which provides only internal access within the VPC.

To access it externally, we must change the service type to **LoadBalancer**.

# Accessing the Project Externally Using LoadBalancer Service Type

Run:

```bash
kubectl get svc | grep frontend-proxy
```
Copy the service name and edit it:

```bash
kubectl edit svc <service-name>
```
Go to the end of the file and change the service type from `ClusterIP` to `LoadBalancer`.
Save the file and wait a few minutes for Kubernetes to update the service to the LoadBalancer type.

Once this is done, the Kubernetes API server sends instructions to the Cloud Controller Manager (CCM).
If you run `kubectl get svc`, you may see an external address appear. The CCM provisions a public FQDN, but it can take a few minutes to become available.

In AWS, a Load Balancer is automatically created. Go to EC2 → Load Balancers and make sure you are in the correct region (for example, us-west-2). You will see a newly created load balancer.

Copy the DNS name and access it using port 8080:

```bash
<LoadBalancer-DNS>:8080
```
Now the application is accessible externally, and the OpenTelemetry project is successfully deployed.

<img width="1833" height="976" alt="image" src="https://github.com/user-attachments/assets/f3175f19-f22a-4aa8-8471-f72c61791e3c" />

## Disadvantages of LoadBalancer service type

  1. Not declarative --> You cannot configure HTTPS, certificates, routing, or health checks in YAML, changes must be done manually in the cloud console.
  
  2. Not cost-effective -->Each service creates a separate load balancer.  
      Multiple services = multiple expensive load balancers.  

  3. Lack of flexibility  --> Tied to cloud provider load balancer (e.g., AWS ALB).  
       Cannot easily use NGINX, F5, Traefik, or Envoy.  
         
  4. Depends on Cloud Controller Manager (CCM)  
    - Won’t work in environments without CCM (e.g., Minikube).  

  5. Limited configuration control  
    - Cannot define advanced load balancer settings like routing rules, TLS, algorithms, etc.  

## Ingress and Ingress Controllers

Ingress is a popular term used to refer to incoming traffic, while egress refers to outgoing traffic. In Kubernetes, Ingress is a resource (like Deployment, Service, ConfigMap, and Secret) that helps define routing rules for incoming traffic to a service or cluster.
For example, we created an EKS cluster and deployed a frontend service. By default, the frontend service uses ClusterIP, which is accessible only within the cluster. To expose it externally, we changed the service type to LoadBalancer. The Kubernetes API server then instructed the Cloud Controller Manager, which created a load balancer inside the VPC. External users can access the application through the load balancer DNS, and traffic is forwarded to the frontend service.
However, organizations usually require access only through a custom domain name, not through a random load balancer DNS or IP address. For example, users access walmart using walmart.com, not using its IP address. This is enforced using routing rules.

These routing rules are defined using the Ingress resource.

When you create an Ingress resource, nothing happens by default. The Ingress Controller reads the Ingress YAML file and creates/configures the load balancer based on the defined rules. These rules can include host-based routing (example.com) or path-based routing (example.com/app).

The Ingress resource typically includes:

```bash
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: minimal-ingress
  annotations:
    # Example: Customizing NGINX behavior
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: "app.example.com"
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-service
            port:
              number: 80
```

Ingress works together with:

Deployment → creates pods
Service → provides internal access
Ingress → controls external access and routing

You usually create Ingress only for services that need external access, such as a frontend proxy. Internal services do not require Ingress.

### Ingress controllers

It is not available by default in the cluster. Kubernetes is not opinionated about which Ingress Controller should be used. This means Kubernetes does not provide a default controller. Instead, it provides the flexibility to choose any Ingress Controller or load balancer based on the requirements.

For example, you may want to use:

  - AWS Application Load Balancer (ALB)  
  - NGINX Ingress Controller  
  - Kong Ingress Controller    
  - Traefik Ingress Controller
  - F5 Ingress Controller

Different controllers provide different capabilities. Some support host-based routing, path-based routing, TLS termination, rate limiting, blacklisting, whitelisting, and other advanced features. Therefore, Kubernetes allows you to deploy the Ingress Controller yourself.

Most load balancer or gateway providers offer their own Ingress Controller implementations, usually deployed as Kubernetes controllers running inside the cluster.

It is important to remember that creating only an Ingress resource does nothing unless an Ingress Controller is deployed. The controller watches the Ingress resources, reads the YAML configuration, and configures routing for external traffic. Depending on the controller, it may create a cloud load balancer or use a reverse proxy running inside the cluster.

For this project, we will deploy the AWS **ALB Ingress Controller**.

## How to setup ALB ingress controller

Before installing the ALB controller, There is an important concept called `IAM OIDC Provider`.

The ALB controller runs as a pod inside the EKS cluster. Its job is to create an `AWS Elastic Load Balancer`.

But normally, to create AWS resources, you need IAM permissions.

So the question is:
How can a pod inside Kubernetes create AWS resources?

This works by:

  - Pods use Service Accounts
  - Service Accounts are linked to IAM Roles
  - IAM Roles have permissions
  - The connection between Service Account and IAM Role is done using OIDC provider

So the flow is:

Pod → Service Account → IAM Role → AWS Permissions

That’s why we first install the IAM OIDC provider.

To do this:

##  Setup OIDC Connector

### commands to configure IAM OIDC provider 

```
export cluster_name=<your-cluster-name>
```
When you run aws eks describe-cluster for a cluster, it returns an OIDC ID. Use the command below to save the OIDC ID in the oidc_id variable

```
oidc_id=$(aws eks describe-cluster --name $cluster-name --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5) 
```

echo $oidc_id

Now, we will associate IAM oidc provider with the cluster, so it is basically adding IAM oidc provider to the cluster - 

```
eksctl utils associate-iam-oidc-provider --cluster $cluster-name --approve
```

## Download IAM policy

```
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/install/iam_policy.json
```

Create IAM Policy

```
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json
```

Create IAM Role

```
eksctl create iamserviceaccount \
  --cluster=<your-cluster-name> \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn=arn:aws:iam::<your-aws-account-id>:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve
```

## Deploy ALB controller

Add helm repo

```
helm repo add eks https://aws.github.io/eks-charts
```

Update the repo

```
helm repo update eks
```

Install

```
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \            
  -n kube-system \
  --set clusterName=<your-cluster-name> \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=<region> \
  --set vpcId=<your-vpc-id>
```

Verify that the deployments are running.

```
kubectl get deployment -n kube-system aws-load-balancer-controller
```

You might face the issue, unable to see the loadbalancer address while giving k get ing -n robot-shop at the end. To avoid this your **AWSLoadBalancerControllerIAMPolicy** should have the required permissions for elasticloadbalancing:DescribeListenerAttributes.

## Run the following command to retrieve the policy details and look for **elasticloadbalancing:DescribeListenerAttributes** in the policy document.
```
aws iam get-policy-version \
    --policy-arn arn:aws:iam::<your-aws-account-id>:policy/AWSLoadBalancerControllerIAMPolicy \
    --version-id $(aws iam get-policy --policy-arn arn:aws:iam::<your-aws-account-id>:policy/AWSLoadBalancerControllerIAMPolicy --query 'Policy.DefaultVersionId' --output text)
```

If the required permission is missing, update the policy to include it
## Download the current policy
```
aws iam get-policy-version \
    --policy-arn arn:aws:iam::<your-aws-account-id>:policy/AWSLoadBalancerControllerIAMPolicy \
    --version-id $(aws iam get-policy --policy-arn arn:aws:iam::<your-aws-account-id>:policy/AWSLoadBalancerControllerIAMPolicy --query 'Policy.DefaultVersionId' --output text) \
    --query 'PolicyVersion.Document' --output json > policy.json
```
## Edit policy.json to add the missing permissions
```
{
  "Effect": "Allow",
  "Action": "elasticloadbalancing:DescribeListenerAttributes",
  "Resource": "*"
}
```
## Create a new policy version
```
aws iam create-policy-version \
    --policy-arn arn:aws:iam::<your-aws-account-id>:policy/AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://policy.json \
    --set-as-default
```

## Ingress.yaml to access the website

Now, to use Ingress, first change the service type to NodePort in the frontend proxy microservice `service.yaml`. Then, create an Ingress resource (ingress.yaml) for the frontend proxy service.

```bash
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: frontend-proxy
  annotations:
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
spec:
  ingressClassName: alb
  rules:
    - host: example.com
      http:
        paths:
          - path: "/"
            pathType: Prefix
            backend:
              service:
                name: opentelemetry-demo-frontendproxy
                port:
                  number: 8080
```

Host-based routing is configured using a dummy domain example.com, which is added in the Ingress host field. The Ingress forwards traffic to the frontend proxy service on port 8080.  

Annotations are added to configure the AWS ALB load balancer (internet-facing and target-type IP). The Ingress class name (alb) is specified so that the ALB controller reads the Ingress resource.  

The configuration is then applied using kubectl apply -f ingress.yaml, which creates a load balancer. After provisioning, example.com is added to the local hosts file (/etc/hosts) and mapped to the load balancer IP.  

Finally, accessing example.com opens the frontend proxy through the Ingress.
