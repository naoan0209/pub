#!/bin/bash
set -e

# 初期化タスクとしてjavaのシステムプロパティをセット
source /app/tomcat.env  # 実際はECS環境変数からファイル名を渡す

# Tomcatを起動する前に環境変数をエクスポート
export JAVA_OPTS

echo $JAVA_OPTS

# コンテナのメインプロセスを実行
exec "$@"
