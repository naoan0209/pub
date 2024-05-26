# -------------------------------------------------------------------------
# ベースイメージ
# -------------------------------------------------------------------------
FROM public.ecr.aws/aws-observability/aws-for-fluent-bit:stable as base

# タイムゾーンを変更
ENV TZ=Asia/Tokyo
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# -------------------------------------------------------------------------
# Webアプリ用
# -------------------------------------------------------------------------
FROM base as web

COPY ./conf/web/extra.conf /fluent-bit/extra.conf
COPY ./conf/web/parsers.conf /fluent-bit/parsers.conf

# -------------------------------------------------------------------------
# バッチ（Java）用
# -------------------------------------------------------------------------
FROM base as java

COPY ./conf/java/extra.conf /fluent-bit/extra.conf
COPY ./conf/java/parsers.conf /fluent-bit/parsers.conf

# -------------------------------------------------------------------------
# バッチ（シェルスクリプト）用
# -------------------------------------------------------------------------
FROM base as shell

COPY ./conf/shell/extra.conf /fluent-bit/extra.conf
COPY ./conf/shell/parsers.conf /fluent-bit/parsers.conf

# -------------------------------------------------------------------------
# バッチ（Python）用
# -------------------------------------------------------------------------
FROM base as python

COPY ./conf/python/extra.conf /fluent-bit/extra.conf
COPY ./conf/python/parsers.conf /fluent-bit/parsers.conf
