**CI/CD** stands for Continuous Integration and Continuous Delivery (or Deployment). It is a DevOps practice used to automate building, testing, and deploying applications.

## Continuous Integration (CI)

Continuous Integration means automatically testing and building code whenever developers push changes.

When a developer creates a pull request:

  - Code is checked out automatically
  - Unit tests are run
  - Static code analysis is performed
  - Application is built
  - Docker image is created
  - Security scans are executed

If all checks pass, the code can be safely merged.

Goal of CI is to catch bugs early and ensure code quality.

## Continuous Delivery (CD)

Continuous Delivery means automatically deploying the application after CI succeeds.

After CI:

  - Docker image is pushed
  - Kubernetes manifests are updated
  - Application is deployed to a cluster
  - Testers can validate the new version

Goal of CD: Release software faster and reliably.

### Advantages of CI/CD

Reduces manual work
Finds bugs early
Improves code quality
Speeds up releases
Makes deployments consistent
Reduces human errors
