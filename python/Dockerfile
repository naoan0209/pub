# -------------------------------------------------------------------------
# ビルドステージ
# -------------------------------------------------------------------------
FROM public.ecr.aws/docker/library/python:3.12-bookworm as build

WORKDIR /app

ENV PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=600

# Pythonパッケージをインストール（pipの例）
COPY ./requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# -------------------------------------------------------------------------
# 実行ステージ
# -------------------------------------------------------------------------
# Debianベース
FROM public.ecr.aws/docker/library/python:3.12-slim-bookworm

WORKDIR /app

ENV PYTHONUNBUFFERED=1

# パッケージをアップデート、追加パッケージをインストール
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y locales unzip jq && \
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

# # aws cliをインストール（Pythonバッチでは不要）
# RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" && \
#     unzip ./awscliv2.zip && \
#     ./aws/install && \
#     rm -f ./awscliv2.zip

# アプリケーション実行ユーザを変更
ARG USER=appuser
ARG GROUP=appgroup
ARG UID=1000
ARG GID=1000

RUN groupadd -g ${GID} ${GROUP} && \
    useradd -u ${UID} -g ${GROUP} -d /app -s /sbin/nologin -l ${USER} && \
    chown -R ${USER}:${GROUP} /app

USER ${USER}

# キック用シェルスクリプトをコピー（一例）
COPY --chown=${USER}:${GROUP} ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# ビルドステージでインストールしたパッケージをコピー
COPY --chown=${USER}:${GROUP} --from=build /usr/local/lib/python3.12/site-packages/ /usr/local/lib/python3.12/site-packages/

# アプリケーションをコピー
COPY --chown=${USER}:${GROUP} ./src/ /app/src/

# アプリケーションを実行
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["python", "./src/task.py"]
