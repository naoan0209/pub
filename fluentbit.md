ECS Fargateタスクで複数のコンテナ（Apache, Tomcat）が同居しており、それぞれのログをFireLensを使ってCloudWatch LogsとAmazon S3に異なる出力先（ロググループとS3バケット）に出力する場合、以下のような手順で設定を行います。この設定では、ApacheとTomcatのログをそれぞれ異なるCloudWatch LogsのロググループとS3バケットに送信することができます。

### ステップ 1: タスク定義の作成

まず、Apache、Tomcat、およびFireLens（カスタムFluent Bitコンテナ）を含むECS Fargateタスク定義を作成します。この際、ApacheとTomcatコンテナの`logConfiguration`でFireLensを使用するように指定します。

```json
{
  "containerDefinitions": [
    {
      "name": "apache",
      "image": "httpd:latest",
      "essential": true,
      "logConfiguration": {
        "logDriver": "awsfirelens",
        "options": {
          "Name": "apache_log",
          "tag": "apache"
        }
      }
    },
    {
      "name": "tomcat",
      "image": "tomcat:latest",
      "essential": true,
      "logConfiguration": {
        "logDriver": "awsfirelens",
        "options": {
          "Name": "tomcat_log",
          "tag": "tomcat"
        }
      }
    },
    {
      "name": "firelens",
      "image": "amazon/aws-for-fluent-bit:latest",
      "essential": true,
      "firelensConfiguration": {
        "type": "fluentbit"
      },
      "memory": 256
    }
  ],
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "256",
  "memory": "512",
  "networkMode": "awsvpc"
}
```

### ステップ 2: Fluent Bitの設定

FireLensを使ってApacheとTomcatのログをそれぞれCloudWatch LogsとS3に送信するためのFluent Bit設定を用意します。以下は`fluent-bit.conf`の例です。

```ini
[SERVICE]
    Flush        1
    Log_Level    info
    Daemon       Off
    Parsers_File parsers.conf

[INPUT]
    Name   forward
    Listen 0.0.0.0
    Port   24224

[FILTER]
    Name    modify
    Match   apache
    Set     log_group_name apache-logs
    Set     s3_bucket your-apache-logs-s3-bucket

[FILTER]
    Name    modify
    Match   tomcat
    Set     log_group_name tomcat-logs
    Set     s3_bucket your-tomcat-logs-s3-bucket

[OUTPUT]
    Name            cloudwatch
    Match           apache
    region          your-region
    log_group_name  apache-logs
    log_stream_prefix  from-fargate-

[OUTPUT]
    Name            cloudwatch
    Match           tomcat
    region          your-region
    log_group_name  tomcat-logs
    log_stream_prefix  from-fargate-

[OUTPUT]
    Name            s3
    Match           apache
    region          your-region
    bucket          your-apache-logs-s3-bucket
    s3_key_format   /apache/%Y/%m/%d/%H/%M/%S.log
    total_file_size 1M
    upload_timeout  1m
    use_put_object  On

[OUTPUT]
    Name            s3
    Match           tomcat
    region          your-region
    bucket          your-tomcat-logs-s3-bucket
    s3_key_format   /tomcat/%Y/%m/%d/%H/%M/%S.log
    total_file_size 1M
    upload_timeout  1m
    use_put_object  On
```

この設定では、ApacheのログとTomcatのログをそれぞれ異なるCloudWatch LogsのロググループとS3バケットに送信するように指定しています。`Match`ディレクティブを使用して、ログのタグに基づいて出力先を分岐させています。


---

"options": {
          "Name": "tomcat_log",
          "tag": "tomcat"
        }
ここで定義した情報に基づいてfluent-bit.confのMatchを制御しているということですか


はい、その理解で正確です。`options`に設定した`"tag": "tomcat"`という情報は、Fluent Bitにおけるログのタグ付けに使用され、このタグを元に`fluent-bit.conf`内でのログのルーティング（どのログがどの`[OUTPUT]`に送信されるか）を制御しています。

ECSタスク定義でコンテナの`logConfiguration`に`"tag": "tomcat"`のように指定すると、そのコンテナから出力されるログはすべて`tomcat`というタグが付けられます。Fluent Bitの設定ファイル(`fluent-bit.conf`)内で、`[INPUT]`セクションで受け取ったログを処理する際に、このタグに基づいてどの`[FILTER]`や`[OUTPUT]`セクションが適用されるかを決定します。

例えば、以下のような`[OUTPUT]`セクションがあるとします。

```ini
[OUTPUT]
    Name            cloudwatch
    Match           tomcat
    ...
```

ここでの`Match`ディレクティブが`tomcat`に設定されているため、タグが`tomcat`であるログのみがこの出力セクションにマッチし、CloudWatchに送信されることになります。同様に、他の出力先（例えばS3）にも異なるタグを用いることで、ApacheのログとTomcatのログを別々にルーティングすることが可能です。

このように、Fluent Bitのタグとマッチングシステムを利用することで、複数のログソースを効率的に異なる出力先に振り分け、管理することができます。
