# GitHub Actions

GitHub Actions is a CI orchestrator provided by GitHub. If your source code is stored in a GitHub repository, you can create CI workflows directly inside that repository.

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
