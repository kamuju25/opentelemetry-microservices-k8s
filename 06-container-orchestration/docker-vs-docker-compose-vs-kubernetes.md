# Docker vs Docker Compose vs Kubernetes

**Docker, Docker Compose, and Kubernetes are related but serve different purposes.**

`Docker` is used to create and run containers.  
It solves the problem of “it works on my machine” by packaging the application with all its dependencies so it runs consistently across environments.

`Docker Compose` is used to run multiple containers together.
You define services like UI, backend, and database in a single YAML file and start everything with one command.
It is mainly used for development and testing.

`Kubernetes` is a container orchestration platform used to manage containers in production.  
It provides advanced capabilities required for scalable and reliable systems.

## Why Choose Kubernetes?

We choose Kubernetes when we need to run applications in production because it provides:

  - `Service discovery` → No need to depend on changing IP addresses
  - `Auto-scaling` → Automatically scales applications based on load
  - `Self-healing` → Restarts failed containers automatically
  - `Load balancing` → Distributes traffic efficiently
  - `High availability` → Ensures applications are always running
  - `Rolling updates & rollback` → Deploy without downtime
