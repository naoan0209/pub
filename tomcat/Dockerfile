# -------------------------------------------------------------------------
# ビルドステージ
# -------------------------------------------------------------------------
FROM public.ecr.aws/docker/library/maven:3.9.6-amazoncorretto-21-al2023 as build
WORKDIR /app

# アプリケーションのビルド
COPY ./app/src /app/src
COPY ./app/pom.xml /app
RUN mvn package

# -------------------------------------------------------------------------
# 実行ステージ
# -------------------------------------------------------------------------
FROM public.ecr.aws/docker/library/tomcat:9.0.87-jdk21-corretto-al2

# タイムゾーンをJSTに設定
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# パッケージをアップデート
RUN yum update -y && \
    yum clean all

# ビルドステージで生成したwarファイルをコピー
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/
# war以外のアプリケーション関連ファイルをコピー
COPY ./app/conf/server.xml /usr/local/tomcat/conf/server.xml
COPY ./app/webapps/ROOT/index.jsp /usr/local/tomcat/webapps/ROOT/index.jsp
# # アクセスログを標準出力にリンク（server.xmlのAccessLogValveを参照）
# RUN ln -sf /dev/stdout /usr/local/tomcat/logs/access_log.txt

# キック用シェルスクリプトをコピー
COPY ./shell/tomcat.env /app/tomcat/
COPY ./shell/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# アプリケーションの実行ユーザを作成
RUN yum install -y shadow-utils && \
    yum clean all && \
    groupadd appgroup && \
    useradd appuser -g appgroup -d /usr/local/tomcat -s /bin/bash && \
    chown -R appuser:appgroup /usr/local/tomcat

# 作成したユーザでアプリケーションを実行
USER appuser

# シェルスクリプトで初期化処理を行ってからアプリケーションを実行
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["catalina.sh", "run"]
