# Debian系ベースイメージ
FROM public.ecr.aws/docker/library/httpd:2.4.59

# パッケージをアップデート、追加パッケージをインストール
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y locales && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# タイムゾーンをJSTに設定
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# ロケールを変更
RUN sed -i '/ja_JP.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

# 設定ファイルをコピー
# COPY ./conf/httpd.conf /usr/local/apache2/conf/httpd.conf

# アプリケーションの実行ユーザを作成
RUN groupadd appgroup && \
    useradd appuser -g appgroup && \
    chown -R appuser:appgroup /usr/local/apache2

# 作成したユーザでアプリケーションを実行
USER appuser
