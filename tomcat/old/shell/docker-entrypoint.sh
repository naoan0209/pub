#!/bin/bash
set -e

# 初期化タスクとしてjavaのシステムプロパティをセット、実際はECS環境変数からファイル名を渡すため不要
if [ -f /app/shell/tomcat.env ]; then
    source /app/shell/tomcat.env
fi

# # Tomcatを起動する前に環境変数をエクスポート
# export JAVA_OPTS
# echo $JAVA_OPTS

# コンテナのメインプロセスを実行
exec "$@"
