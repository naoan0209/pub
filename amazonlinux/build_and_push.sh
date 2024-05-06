#!/bin/bash

ACCOUNT="977566148511"
CONTAINER="amazonlinux"

if [ -z "${ACCOUNT}" ]; then
    echo "error: account id is not defined."
    exit 255
fi

aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin ${ACCOUNT}.dkr.ecr.ap-northeast-1.amazonaws.com

docker build --no-cache -t "${CONTAINER}" .

docker tag ${CONTAINER}:latest ${ACCOUNT}.dkr.ecr.ap-northeast-1.amazonaws.com/${CONTAINER}:latest

docker push ${ACCOUNT}.dkr.ecr.ap-northeast-1.amazonaws.com/${CONTAINER}:latest
