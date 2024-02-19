`docker-entrypoint.sh` は、Docker コンテナが起動する際に実行されるスクリプトで、コンテナの初期化プロセスをカスタマイズするためによく使用されます。このスクリプトは、コンテナが実行する主なプロセス（エントリーポイント）の前に実行され、環境変数の設定、設定ファイルの動的な書き換え、初期化タスクの実行、データベースの準備など、様々な初期化作業を行うことができます。

### docker-entrypoint.sh の使用方法

1. **スクリプトの作成**: `docker-entrypoint.sh` スクリプトを作成し、コンテナ起動時に実行したいコマンドを記述します。

```bash
#!/bin/bash
# 例: 環境変数をチェックし、必要に応じてデフォルト値を設定
if [ -z "$MY_ENV_VAR" ]; then
    export MY_ENV_VAR="default_value"
fi

# 初期化タスクを実行
# 例: データベースマイグレーション
python manage.py migrate

# コンテナのメインプロセスを実行（例: Apacheサーバーの起動）
exec "$@"
```

2. **Dockerfile にスクリプトを追加**: `docker-entrypoint.sh` を Docker イメージ内にコピーし、実行可能に設定した後、エントリーポイントとして指定します。

```Dockerfile
FROM python:3.8
# アプリケーションのソースコードをコピー
COPY . /app
WORKDIR /app

# docker-entrypoint.sh スクリプトをコピーして実行可能に設定
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# エントリーポイントを設定
ENTRYPOINT ["docker-entrypoint.sh"]

# コンテナのメインプロセスを指定（例: gunicornでDjangoアプリケーションを実行）
CMD ["gunicorn", "myapp.wsgi:application"]
```

### 注意点

- `exec "$@"` コマンドは、スクリプトに渡された引数（`CMD` や `docker run` コマンドからの追加引数）を使ってコンテナのメインプロセスを実行します。これにより、コンテナが正常にシグナルを受け取り、停止や再起動のプロセスを適切に処理できるようになります。
- スクリプト内でエラーが発生した場合、コンテナが予期せず終了する可能性があるため、エラーハンドリングに注意してください。
- `docker-entrypoint.sh` はカスタマイズが容易であるため、特定のアプリケーションや環境に合わせて柔軟に初期化処理を実装することができます。
