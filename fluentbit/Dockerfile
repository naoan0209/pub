FROM public.ecr.aws/aws-observability/aws-for-fluent-bit:stable

# タイムゾーン
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# カスタムコンフィグ。ECSタスク定義の "config-file-value" と一致させる
COPY ./fluent-bit-custom.conf /fluent-bit/custom.conf

# パーサ
COPY ./parsers.conf /fluent-bit/parsers.conf
