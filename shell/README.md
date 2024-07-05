# バッチを1分間隔で実行するシェルスクリプト

## 注意点

- SIGTERMが送られてからSIGKILLが送られるまで、Dockerではデフォルト10秒の猶予しかない
- そのため、テスト時は次のように時間を120秒程度まで伸ばす `docker container stop temurin -t 120`
- ECSにおいては、コンテナのタイムアウト設定（stopTimeout）を120秒にすること
