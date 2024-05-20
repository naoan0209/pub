# -------------------------------------------------------------------------
# ビルドステージ
# -------------------------------------------------------------------------
FROM public.ecr.aws/docker/library/maven:3.9.6-eclipse-temurin-21-jammy as build

WORKDIR /app

# ソースコードをコピー
COPY ./app/src/ /app/src/

# ビルド定義ファイルをコピー
COPY ./app/pom.xml /app/pom.xml

# ビルド
RUN mvn package

# -------------------------------------------------------------------------
# 実行ステージ
# -------------------------------------------------------------------------
# Ubuntuベース
FROM public.ecr.aws/docker/library/eclipse-temurin:21.0.2_13-jre-jammy

WORKDIR /app

# パッケージをアップデート、追加パッケージをインストール
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y language-pack-ja unzip jq && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# タイムゾーンを変更
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# ロケールを変更
ENV LANG=ja_JP.UTF-8
ENV LANGUAGE=""
ENV LC_ALL=""

# # aws cliをインストール
# # Java系バッチでは不要
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

# ビルドステージでビルドしたアプリケーションをコピー
COPY --chown=${USER}:${GROUP} --from=build /app/ /app/

# キック用シェルスクリプトをコピー（一例）
COPY --chown=${USER}:${GROUP} ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# アプリケーションを実行
CMD ["java", "-jar", "target/myapp.jar"]
