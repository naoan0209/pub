# -------------------------------------------------------------------------
# ビルドステージ
# -------------------------------------------------------------------------
FROM public.ecr.aws/docker/library/maven:3.9.6-eclipse-temurin-21-jammy as build
WORKDIR /app

# ソースコードとビルド定義ファイルをコピー
COPY ./app/ /app/

# ビルド
RUN mvn clean install

# -------------------------------------------------------------------------
# 実行ステージ
# -------------------------------------------------------------------------
# Ubuntuベース
FROM public.ecr.aws/docker/library/tomcat:10.1.20-jre21-temurin-jammy as svc

# パッケージをアップデート、追加パッケージをインストール
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y language-pack-ja && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# タイムゾーンを変更
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# ロケールを変更
ENV LANG=ja_JP.UTF-8
ENV LANGUAGE=
ENV LC_ALL=

# アプリケーション実行ユーザを変更
ARG USER=appuser
ARG GROUP=appgroup
ARG UID=1000
ARG GID=1000

RUN groupadd -g ${GID} ${GROUP} && \
    useradd -u ${UID} -g ${GROUP} -d "${CATALINA_HOME}" -s /sbin/nologin -l ${USER} && \
    chown -R ${USER}:${GROUP} "${CATALINA_HOME}"

USER ${USER}

# ビルドステージで生成したwarファイルをコピー
COPY --chown=${USER}:${GROUP} --from=build /app/healthcheck/target/ROOT.war "${CATALINA_HOME}"/webapps/ROOT.war
COPY --chown=${USER}:${GROUP} --from=build /app/myapp/target/myapp.war "${CATALINA_HOME}"/webapps/myapp.war

# war以外のアプリケーション関連ファイルをコピー
COPY --chown=${USER}:${GROUP} ./app/conf/ "${CATALINA_HOME}"/conf/
