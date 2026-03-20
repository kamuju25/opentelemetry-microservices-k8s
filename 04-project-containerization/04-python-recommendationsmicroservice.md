# Containerization of recommendation microservice

## Here we will write a Dockerfile for recommendation microservice which is written in Python language.

```bash
FROM python:3.12-slim-bookworm AS base

WORKDIR /usr/src/app

COPY requirements.txt ./

RUN python -m pip install --upgrade pip
RUN pip install -r requirements.txt

COPY . .

ENTRYPOINT ["python", "recommendation_server.py"]
```
Now build the image

```bash
docker build -t naveen/recommendationservice:v1 .
```
Now run the image

```bash
docker run naveen/recommendationservice:v1
```
