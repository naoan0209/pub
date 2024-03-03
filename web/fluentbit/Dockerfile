FROM public.ecr.aws/aws-observability/aws-for-fluent-bit:stable

RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

COPY ./fluent-bit-custom.conf /fluent-bit/custom.conf
