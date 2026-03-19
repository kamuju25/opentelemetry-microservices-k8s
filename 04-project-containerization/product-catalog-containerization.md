# Containerization of product catalog service

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
