## How to Build Locally

Go to the cloned repository and navigate to the ad service:

```bash
cd <your-open-tel-repo>/src/ad
```
As per the READme.md file in `src/ad/READme.md` file - run the below commands -

```bash
sudo apt install openjdk-21-jre-headless -y
```

`./gradlew installDist` --> ./gradlew runs the Gradle wrapper included in the project. It ensures the build uses the project’s exact Gradle version and removes the need to install Gradle globally, since the wrapper automatically downloads and uses the correct version defined in the project.

installDist is a Gradle task provided by the Application plugin. When executed, it builds the application, packages all required dependencies, creates a runnable distribution, and generates startup scripts inside a bin/ directory so the service can be launched directly.

To run the Ad Service:

```bash
export AD_PORT=<port-number>
export FEATURE_FLAG_GRPC_SERVICE_ADDR=featureflagservice:50053
./build/install/opentelemetry-demo-ad/bin/Ad
```

## Containerization of ad microservice

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
docker build -t <imagename=kamuju25/ad-microservice:v1> .
```
Now run the image

```bash
docker run <imagename=kamuju25/ad-microservice:v1>
```

To push to Docker hub

```bash
docker login -u <username>
docker push <imagename=kamuju25/ad-microservice:v1>
```
