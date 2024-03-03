FROM public.ecr.aws/aws-observability/aws-for-fluent-bit:stable

RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

#  ECSタスク定義の "config-file-value": "/fluent-bit/custom.conf" と一致させる
COPY ./fluent-bit-custom.conf /fluent-bit/custom.conf
