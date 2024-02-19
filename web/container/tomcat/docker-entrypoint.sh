#!/bin/bash
set -e

# 例
if [ -z "$MY_ENV_VAR" ]; then
    export MY_ENV_VAR="default_value"
fi

# 初期化タスクを実行
# javaのシステムプロパティをセット
JAVA_OPTS="$JAVA_OPTS -Dsome.property=value"

# Tomcat を起動する前に環境変数をエクスポート
export JAVA_OPTS

# コンテナのメインプロセスを実行
exec "$@"
