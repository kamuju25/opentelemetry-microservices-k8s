In the same way, the remaining services can also be containerized and pushed to a registry.

In a microservices architecture, running each service manually requires multiple steps, such as:

  - Creating Docker networks
  - Creating volumes
  - Pulling images
  - Running containers in the correct order

This process becomes complex and time-consuming.

Docker Compose solves this problem by allowing us to define and manage all services, networks, and volumes in a single docker-compose.yml file, enabling us to run multiple containers using one configuration file.

Using a single command (`docker-compose up`), which is already demonstrated in `03-opentelemetry-installation`, we can start the entire application stack.

# Docker Compose Overview

## 1. Services

Services describe the containers that will run in a Docker Compose setup. Each service usually represents a component of your application (like a frontend, backend, or database).

**What Do Services Include?**

  - Image: The Docker image used to create the container.
  - Build: Instructions to build an image if one is not already available.
  - Ports: Maps container ports to the host system.
  - Environment: Sets environment variables inside the container.
  - Depends_on: Defines the order in which services should start (but does not guarantee the service is fully ready).

## 2. Networks

Networks allow containers to communicate with each other. Containers on the same network can connect using service names as hostnames.

**What Do Networks Include?**

  - Driver: Specifies the type of network (e.g., bridge, overlay).
  - Attachable: Allows standalone containers to connect to the network (mainly used with overlay networks).

## 3. Volumes

Volumes are used to store data outside the container so it is not lost when the container stops or is removed. This helps keep data safe and reusable.

**What Do Volumes Include?**

  - Named Volumes: Docker-managed storage that can be shared across containers.
  - Bind Mounts: Links a folder from your host machine to a container directory.
