# -------------------------------------------------------------------------
# ビルドステージ
# -------------------------------------------------------------------------
# https://gallery.ecr.aws/amazoncorretto/amazoncorretto
FROM public.ecr.aws/amazoncorretto/amazoncorretto:21-al2023-jdk AS build
WORKDIR /app

# SaySomething.javaのコピー
COPY SaySomething.java .

# SaySomething.javaのコンパイル
RUN javac SaySomething.java

# -------------------------------------------------------------------------
# 実行ステージ
# -------------------------------------------------------------------------
FROM public.ecr.aws/amazoncorretto/amazoncorretto:21.0.2-al2023-headless

# ビルドステージからコンパイル済みのSaySomething.classをコピー
WORKDIR /app
COPY --from=build /app/SaySomething.class .

# パッケージをアップデート
RUN dnf upgrade -y --releasever=latest && \
    dnf clean all

# タイムゾーンをJSTに設定
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# アプリケーションの実行ユーザを作成、アプリケーション用ディレクトリの権限を変更
RUN dnf install -y shadow-utils && \
    dnf clean all && \
    groupadd appgroup && \
    useradd appuser -g appgroup && \
    chown -R appuser:appgroup /app

# 作成したユーザでアプリケーションを実行
USER appuser

# アプリケーションを実行
ENTRYPOINT ["java", "SaySomething"]
