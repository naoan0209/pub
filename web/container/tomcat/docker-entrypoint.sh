#!/bin/bash
set -e

# 初期化タスクとしてjavaのシステムプロパティをセット
JAVA_OPTS="$JAVA_OPTS -Dsome.property=value"

# Tomcatを起動する前に環境変数をエクスポート
export JAVA_OPTS

# コンテナのメインプロセスを実行
exec "$@"
