## GitOps  

GitOps stores Kubernetes manifests in a version control system (usually Git). A CD tool (like Argo CD) monitors the repo and deploys changes automatically. Git (version control) becomes the source of truth for deployments.

### Advantages of GitOps

  - Automatic deployment when repo changes are detected
  - Reconciliation — if someone manually changes the cluster, GitOps resets it back to Git state
  - Continuous sync — runs every few minutes automatically
  - Version-controlled deployments with traceability

## Install and Configure Argo CD
You can follow the official documentation: [Argo-CD](https://argo-cd.readthedocs.io/en/stable/getting_started/)

First, a namespace called argocd is created and the Argo CD YAML file is applied, which deploys multiple components such as the Git state controller, Kubernetes state controller, UI server, and authentication services. After installation, pods and services are verified using kubectl commands. The Argo CD server service is then exposed as a LoadBalancer (or Ingress) to access the UI. To log in, the username is admin and the password is retrieved from a Kubernetes secret and decoded from base64. It is not required that Argo CD to be run on the same cluster; it can be deployed centrally and manage multiple Kubernetes clusters using a hub-and-spoke model. Finally, the next step is to connect Argo CD to a Git repository so it can automatically deploy new application versions to the cluster.
