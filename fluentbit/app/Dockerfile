# -------------------------------------------------------------------------
# ビルドステージ
# -------------------------------------------------------------------------
# FROM public.ecr.aws/docker/library/eclipse-temurin:21.0.2_13-jdk-jammy as build
FROM public.ecr.aws/docker/library/maven:3.9.6-eclipse-temurin-21-jammy as build
WORKDIR /app

# アプリケーションのビルド
COPY ./src ./src
COPY ./pom.xml .

RUN mvn package

# -------------------------------------------------------------------------
# 実行ステージ
# -------------------------------------------------------------------------
FROM public.ecr.aws/docker/library/eclipse-temurin:21.0.2_13-jre-jammy
# タイムゾーンをJSTに設定
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# ビルドステージでビルドしたアプリケーションをコピー
WORKDIR /app
COPY --from=build /app/target/myapp.jar .

# アプリケーションの実行ユーザを作成
RUN groupadd appgroup && \
    useradd appuser -g appgroup && \
    chown -R appuser:appgroup /app

# 作成したユーザでアプリケーションを実行
USER appuser

# アプリケーションを実行
CMD ["java", "-jar", "myapp.jar"]
