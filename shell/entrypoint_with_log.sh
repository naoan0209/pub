#!/bin/bash

# JARファイルのパス
JAR_FILE="./target/MyApp.jar"
JAR_PID=0

# ロギング関数
logging_debug() {
    local message="$1"
    echo "$(date +%Y/%m/%d-%H:%M:%S): $message"
}

logging_debug "PID $$"

# シグナルを受け取ったときに実行する関数
terminate() {
    logging_debug "Termination signal received. Waiting for JAR process to finish..."
    # JARが実行中かチェック
    if [ $JAR_PID -ne 0 ]; then
        # JARが終了するまで待つ
        wait $JAR_PID
    fi
    logging_debug "JAR process finished. Exiting..."
    exit 0
}

# SIGTERMシグナルをキャッチしてterminate関数を実行
trap 'terminate' SIGTERM

# JARファイルを1分おきに実行
while true; do
    logging_debug "Executing JAR file..."

    java -jar "$JAR_FILE" "$@" &
    JAR_PID=$!

    # 1分待機
    logging_debug "Sleeping 60 sec"
    sleep 60
done
