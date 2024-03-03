#!/bin/bash

docker build -t fluentbit .
docker tag fluentbit:latest 977566148511.dkr.ecr.ap-northeast-1.amazonaws.com/fluentbit:latest
docker push 977566148511.dkr.ecr.ap-northeast-1.amazonaws.com/fluentbit:latest
