#!/bin/bash

# JARファイルのパス
JAR_FILE="/path/to/your-file.jar"
JAR_PID=0

# シグナルを受け取ったときに実行する関数
terminate() {
    # JARが実行中かチェック
    if [ $JAR_PID -ne 0 ]; then
        # JARが終了するまで待つ
        wait $JAR_PID
    fi
    exit 0
}

# SIGTERMシグナルをキャッチしてterminate関数を実行
trap 'terminate' SIGTERM

# 無限ループでJARファイルを1分おきに実行
while true; do
    java -jar "$JAR_FILE" &
    JAR_PID=$!

    # 1分待機
    sleep 60

    # JARプロセスの終了を待機
    wait $JAR_PID
done
