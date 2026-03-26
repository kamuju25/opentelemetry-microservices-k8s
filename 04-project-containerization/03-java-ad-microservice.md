# Containerization of ad microservice

Here we will write a Dockerfile for ad microservice which is written in Java language.

```bash
FROM eclipse-temurin:21-jdk AS builder

WORKDIR /usr/src/app/

COPY gradlew* settings.gradle* build.gradle . # By copying these first, Docker can cache your dependencies. If you change your code but not your dependencies, Docker skips the slow "downloading" phase.

RUN chmod +x ./gradlew
RUN ./gradlew
RUN ./gradlew downloadRepos

COPY . .
COPY ./pb ./proto # Specifically takes your local Protobuf definitions (from a folder named pb) and puts them into a folder named proto inside the container
RUN chmod +x ./gradlew
RUN ./gradlew installDist -PprotoSourceDir=./proto

#########################################

FROM eclipse-temurin:21-jre

WORKDIR /usr/src/app

COPY --from=builder /usr/src/app/ ./

ENV AD_PORT 9099

ENTRYPOINT ["./build/install/opentelemetry-demo-ad/bin/Ad"]
```
Now build the image

```bash
docker build -t <imagename=kamuju25/product-catalog:v1> .
```
Now run the image

```bash
docker run <imagename=kamuju25/product-catalog:v1>
```

To push to Docker hub

```bash
docker login -u <username>
docker push <imagename=kamuju25/product-catalog:v1>
```
