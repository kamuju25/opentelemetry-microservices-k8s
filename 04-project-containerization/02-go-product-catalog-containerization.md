## Local build & validation

It is a best practice to run an application or microservice locally before creating a Dockerfile because it helps confirm that the application works correctly on its own. By doing this, we understand how the application is built, what dependencies and environment variables it requires, and how it should be executed. This prevents confusion later, since if something fails inside Docker, it will be clear that the issue is with the container setup and not the application itself.

### How to Build Locally

Go to the cloned repository:

```bash
git clone <your-opentel-repo-url>
```
Navigate to the product catalog service:

```bash
cd <your-open-tel-repo>/src/product-catalog
```
Set a unique port for the service:

```bash
export PRODUCT_CATALOG_PORT=<any-unique-port>
```
Build the application:

```bash
go build -o product-catalog .
```
**go build -o product-catalog .** → This command compiles the Go application and creates an executable binary named product-catalog.

Finally, run the executable:

```bash
./product-catalog
```
You should see output like this as mentioned in the `README.md` file of product-catalog microservice in src folder, which indicates the microservice is running successfully:  

INFO[0000] Loaded 10 products  
INFO[0000] Product Catalog gRPC server started on port: 8088  


## Containerization of product catalog service

Here we will write a Dockerfile for product catalog service which is written in Go language.

```bash
FROM golang:1.22-alpine AS builder

WORKDIR /usr/src/app/

COPY . .

RUN go mod download

RUN go build -o product-catalog .

===================

FROM alpine AS release

WORKDIR /usr/src/app/

COPY ./products/ ./products/

COPY --from=builder /usr/src/app/product-catalog/ ./

# As instruction is added in the product-catalog service readme file, export PRODUCT_CATALOG_PORT varaible

ENV PRODUCT_CATALOG_PORT 8088

ENTRYPOINT [ "./product-catalog" ]
```
Now build the image

```bash
docker build -t naveen/product-catalog:v1 .
```

Now run the image

```bash
docker run naveen/product-catalog:v1
```
