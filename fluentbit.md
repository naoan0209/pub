AWS ECSでApacheコンテナとTomcatコンテナを1つのタスクに同居させ、FireLensとカスタムFluent Bitイメージを使用してログを出力する設定は、主に以下の2つの部分から構成されます。

1. **ECSタスク定義の設定**:
   - Apacheコンテナ、Tomcatコンテナ、およびFluent BitをFireLensとして使用するコンテナを定義します。
   - FireLensを使用してログの転送を設定します。

2. **Fluent Bitの設定 (`fluent-bit.conf`)**:
   - ApacheとTomcatのログにタグを付け、ログの出力先を制御するための設定を行います。

### ECSタスク定義の設定

ECSタスク定義では、`logConfiguration`のオプションを使用して、ApacheとTomcatのコンテナからのログをFireLensを介してFluent Bitに送信するように設定します。また、Fluent Bitコンテナを`firelensConfiguration`を使用して定義します。

以下は、ApacheとTomcatのコンテナを含むECSタスク定義のJSONの概要例です（全ての設定オプションは含まれていません）。

```json
{
  "family": "your-task-definition-family",
  "containerDefinitions": [
    {
      "name": "apache",
      "image": "apache-image",
      "logConfiguration": {
        "logDriver": "awsfirelens",
        "options": {
          "Name": "apache_logs",
          "Tag": "apache"
        }
      }
    },
    {
      "name": "tomcat",
      "image": "tomcat-image",
      "logConfiguration": {
        "logDriver": "awsfirelens",
        "options": {
          "Name": "tomcat_logs",
          "Tag": "tomcat"
        }
      }
    },
    {
      "name": "firelens-container",
      "firelensConfiguration": {
        "type": "fluentbit",
        "options": {
          "config-file-type": "file",
          "config-file-value": "/fluent-bit/etc/fluent-bit.conf"
        }
      },
      "image": "custom-fluent-bit-image",
      "essential": true
    }
  ]
}
```

### Fluent Bitの設定 (`fluent-bit.conf`)

Fluent Bitの設定では、ApacheとTomcatのログをそれぞれ異なる出力先に転送するためのフィルターと出力設定を定義します。以下は、`fluent-bit.conf`の例です。

```conf
[SERVICE]
    Flush        1
    Log_Level    info
    Parsers_File parsers.conf

[INPUT]
    Name    forward
    Listen  0.0.0.0
    Port    24224
    Tag     *

[FILTER]
    Name    modify
    Match   apache
    Add     log_type apache

[FILTER]
    Name    modify
    Match   tomcat
    Add     log_type tomcat

[OUTPUT]
    Name          es
    Match         apache
    Host          YOUR_ELASTICSEARCH_ENDPOINT
    Port          443
    Logstash_Format On
    Replace_Dots   On
    TLS           On
    TLS.verify    Off

[OUTPUT]
    Name          s3
    Match         tomcat
    bucket        YOUR_S3_BUCKET_NAME
    region        YOUR_AWS_REGION
    s3_key_format /tomcat-logs/%Y/%m/%d/%H/%M/%S
    use_put_object On
```

この設定では、ApacheとTomcatからのログをそれぞれElasticsearchとAmazon S3に転送しています。`[FILTER]`セクションでログに`log_type`を追加し、これを使用して`[OUTPUT]`セクションでログの出力先を制御しています。

この構成を使用することで、1つのECSタスク内で複数のコンテナからのログを効率的に管理し、異なる出力先に転送することが可能になります。
