# -------------------------------------------------------------------------
# 実行ステージ
# -------------------------------------------------------------------------
FROM public.ecr.aws/amazonlinux/amazonlinux:2023-minimal

WORKDIR /app

# パッケージをアップデート、追加パッケージをインストール
RUN dnf upgrade -y --releasever=latest && \
    dnf install -y tzdata glibc-langpack-ja shadow-utils unzip jq && \
    dnf clean all && \
    rm -rf /var/cache/yum

# タイムゾーンを変更
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# ロケールを変更
ENV LANG=ja_JP.UTF-8

# aws cliをインストール
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" && \
    unzip ./awscliv2.zip && \
    ./aws/install && \
    rm -f ./awscliv2.zip

# アプリケーション実行ユーザを変更
ARG USER=appuser
ARG GROUP=appgroup
ARG UID=1000
ARG GID=1000

RUN groupadd -g ${GID} ${GROUP} && \
    useradd -u ${UID} -g ${GROUP} -d /app -s /sbin/nologin -l ${USER} && \
    chown -R ${USER}:${GROUP} /app

USER ${USER}

# キック用シェルスクリプトをコピー（一例、直接メイン処理のスクリプトを実行するなら不要）
COPY --chown=${USER}:${GROUP} ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# アプリケーションをコピー
COPY --chown=${USER}:${GROUP} ./src/ /app/src/

# アプリケーションを実行
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/bin/bash"]
