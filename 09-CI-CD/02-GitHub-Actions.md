# GitHub Actions

GitHub Actions is a CI orchestrator provided by GitHub. If your source code is stored in a GitHub repository, you can create CI workflows directly inside that repository.

In CI, steps include: unit testing, build, static code analysis, Docker image creation, pushing image, and updating Kubernetes manifests.
After CI updates Kubernetes manifests, CD picks those updates and deploys them to the Kubernetes cluster.

In simpler terms, GitHub Actions is a CI tool provided by GitHub. We create a .github/workflows folder and add a YAML file that defines the workflow name, trigger, jobs, and steps.
Each job runs on a GitHub runner and performs tasks like checkout, build, test, and Docker image creation. This automates the CI process.

To use GitHub Actions, you need to create a folder in your repository called:

```bash
.github/workflows
```
Inside this folder, you place a YAML file, for example:

```bash
github-ci.yaml
```
The name of the file does not matter. This YAML file tells GitHub Actions what steps to run.
GitHub provides pre-built actions that work like plugins. For example:

  - Checkout action → clones the repository
  - Docker login action → logs into the Docker registry
  - Setup language actions → install Go, Java, Node, etc.

So, in the YAML file, you mainly use GitHub Actions instead of writing custom scripts. That’s why it is called GitHub Actions.

This is the github actions YAML file product catalog microservice.

```bash
# CI for Product Catalog Service

name: product-catalog-microservice-ci

on: 
    pull_request:
        branches:
        - main

jobs:
    build:
        runs-on: ubuntu-latest

        steps:
        - name: checkout code
          uses: actions/checkout@v4

        - name: Setup Go 1.22
          uses: actions/setup-go@v2
          with:
            go-version: 1.22
        
        - name: Build
          run: |
            cd src/product-catalog
            go mod download
            go build -o product-catalog-service main.go

        - name: unit tests
          run: |
            cd src/product-catalog
            go test ./...
    
    code-quality:
        runs-on: ubuntu-latest

        steps:
        - name: checkout code
          uses: actions/checkout@v4
        
        - name: Setup Go 1.22
          uses: actions/setup-go@v2
          with:
           go-version: 1.22
        
        - name: Run golangci-lint
          uses: golangci/golangci-lint-action@v6
          with:
            version: v1.55.2
            run: golangci-lint run
            working-directory: src/product-catalog

    docker:
        runs-on: ubuntu-latest

        needs: build

        steps:
        - name: checkout code
          uses: actions/checkout@v4

        - name: Install Docker
          uses: docker/setup-buildx-action@v1
        
        - name: Login to Docker
          uses: docker/login-action@v3
          with:
            username: ${{ secrets.DOCKER_USERNAME }}
            password: ${{ secrets.DOCKER_TOKEN }}

        - name: Docker Push
          uses: docker/build-push-action@v6
          with:
            context: src/product-catalog
            file: src/product-catalog/Dockerfile
            push: true
            tags: ${{ secrets.DOCKER_USERNAME }}/product-catalog:${{github.run_id}}

    
    updatek8s:
        runs-on: ubuntu-latest

        needs: docker

        steps:
        - name: checkout code
          uses: actions/checkout@v4
          with:
            token: ${{ secrets.GITHUB_TOKEN }}

        - name: Update tag in kubernetes deployment manifest
          run: | 
               sed -i "s|image: .*|image: ${{ secrets.DOCKER_USERNAME }}/product-catalog:${{github.run_id}}|" kubernetes/productcatalog/deploy.yaml
        
        - name: Commit and push changes
          run: |
            git config --global user.email "kamuju@gmail.com"
            git config --global user.name "Naveen Krishna Kamuju"
            git add kubernetes/productcatalog/deploy.yaml
            git commit -m "[CI]: Update product catalog image tag"
            git push origin HEAD:main -f
```

After this, make the required changes to the repository and push them to the SCM. This will trigger the CI pipeline as defined in the product-catalog.yaml file.

## GitOps

GitOps stores Kubernetes manifests in a version control system (usually Git). A CD tool (like Argo CD) monitors the repo and deploys changes automatically.
Git (version control) becomes the source of truth for deployments.

Advantages of GitOps

  - Automatic deployment when repo changes are detected
  - Reconciliation — if someone manually changes the cluster, GitOps resets it back to Git state
  - Continuous sync — runs every few minutes automatically
  - Version-controlled deployments with traceability

## Install and Configure Argo CD

Install and configure Argo CD in the EKS cluster.
You can follow the official documentation:

https://argo-cd.readthedocs.io/en/stable/
