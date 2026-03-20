# Installation of Kubectl on Ubuntu ec2 instance

**Download of Kubectl**
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```
**Install Kubectl**
```bash
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```
**Kubectl verification**
```bash
kubectl version --client
```
