# https://gallery.ecr.aws/amazoncorretto/amazoncorretto
FROM public.ecr.aws/amazoncorretto/amazoncorretto:21-al2023-jdk AS build
WORKDIR /app

# SaySomething.javaのコピー
COPY SaySomething.java .

# SaySomething.javaのコンパイル
RUN javac SaySomething.java

# 実行ステージ
FROM public.ecr.aws/amazoncorretto/amazoncorretto:21.0.2-al2023-headless
WORKDIR /app

# ビルドステージからコンパイル済みのSaySomething.classをコピー
COPY --from=build /app/SaySomething.class .

# パッケージのアップデート
RUN dnf upgrade -y --releasever=latest && dnf clean all

# タイムゾーンをJSTに設定
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# root以外で実行
USER nobody

# アプリケーションの実行
ENTRYPOINT ["java", "SaySomething"]
