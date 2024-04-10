# -------------------------------------------------------------------------
# ビルドステージ
# -------------------------------------------------------------------------
FROM public.ecr.aws/docker/library/eclipse-temurin:21.0.2_13-jdk-jammy as build
WORKDIR /app

# アプリケーションのビルド
COPY SaySomething.java .
RUN javac SaySomething.java

# -------------------------------------------------------------------------
# 実行ステージ
# -------------------------------------------------------------------------
FROM public.ecr.aws/docker/library/eclipse-temurin:21.0.2_13-jre-jammy

# パッケージをアップデート、追加パッケージをインストール
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y unzip language-pack-ja && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# タイムゾーンをJSTに設定
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# ロケールを変更
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
RUN update-locale LANG=ja_JP.UTF-8

# aws cliをインストール
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

# ビルドステージでビルドしたアプリケーションをコピー
WORKDIR /app
COPY --from=build /app/SaySomething.class .

# キック用シェルスクリプトをコピー
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# アプリケーションの実行ユーザを作成
RUN groupadd appgroup && \
    useradd appuser -g appgroup && \
    chown -R appuser:appgroup /app

# 作成したユーザでアプリケーションを実行
USER appuser

# アプリケーションを実行
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["java", "SaySomething"]
