Once the images are built, they are pushed to a container registry such as Docker Hub, Quay, Amazon ECS, or any other container registry.

Below are the commands to push the images to Docker Hub.

To authenticate to docker hub
```bash
docker login docker.io
```
To push the image to docker hub
```bash
docker push docker.io/<accountname>/<imagename:tag>
```
