# Debianベース
FROM public.ecr.aws/docker/library/httpd:2.4.59

# パッケージをアップデート、追加パッケージをインストール
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y locales && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# タイムゾーンを変更
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# ロケールを変更
ENV LANG=ja_JP.UTF-8
RUN sed -i '/ja_JP.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen

# アプリケーション実行ユーザを変更
ARG USER=appuser
ARG GROUP=appgroup
ARG UID=1000
ARG GID=1000

RUN groupadd -g ${GID} ${GROUP} && \
    useradd -u ${UID} -g ${GROUP} -d /usr/local/apache2 -s /sbin/nologin -l ${USER} && \
    chown -R ${USER}:${GROUP} /usr/local/apache2

USER ${USER}

# 設定ファイルをコピー
COPY --chown=${USER}:${GROUP} ./conf/ /usr/local/apache2/conf/
COPY --chown=${USER}:${GROUP} ./index.html /usr/local/apache2/htdocs/index.html
