# FluentBit

**親ページ**

| 内容 | Markdownリンク | HTMLリンク |
|---|---|---|
| サイトマップ | [md](../sitemap.md) | <a href="../sitemap.html">html</a> |
| ログ管理 | [md](./log.md) | <a href="./log.md">html</a> |

---

**目次**
- [FluentBit](#fluentbit)
  - [概要](#概要)
    - [できること](#できること)
    - [関連図](#関連図)
    - [リソース構成](#リソース構成)
    - [ログ転送動作](#ログ転送動作)
  - [詳細](#詳細)
    - [INPUT](#input)
    - [FILTER](#filter)
    - [OUTPUT](#output)
    - [ヘルスチェック](#ヘルスチェック)
      - [設定](#設定)
      - [動作](#動作)
  - [改修の手引き](#改修の手引き)

## 概要

- アプリケーションが出力したログをフィルタリングおよびマッチングし、任意のロググループに転送する
- 多機能なソフトウェアだが、必要最低限な一部の機能のみ利用する
- AWS ECS FireLensでの利用を前提とする

### できること

- ログメッセージ種別に応じてログの出力先を選択できる
  - 正規表現でフィルタ可能なことが条件
- CloudWatch Logs以外の出力先を選択できる
  - Firehose不要でS3に直接ログを送信できる
- FluentBitがないとECSアプリケーションはCloudWatch Logsの単一のロググループにしかログを出力できない

**導入していない機能の例**
- ログレベルに応じて出力先を選択する
  - INFOログはCloudWatchに送らない、など
- ログを構造化化して出力する
  - アプリケーションがテキスト形式で出力したログをパースしてjson形式にしてCloudWatchに送る、など

### 関連図

```mermaid
graph LR
    subgraph AWS_Services[AWS Services]
        subgraph Sending_Logs_to_CloudWatch[Sending Logs to CloudWatch]
            RDS[ex: Aurora MySQL]
        end
        subgraph Sending_Logs_to_S3[Sending Logs to S3]
            ALB[ex: ALB]
        end
    end

    subgraph Lambda_Application[Lambda Application]
        Lambda1[Lambda Function 1]
        Lambda2[Lambda Function 2]
    end

    subgraph ECS_Application[ECS Application]
        subgraph ECS_Task[ECS Task]
            subgraph Application
                Apache[Apache]
                Tomcat[Tomcat]
            end
            subgraph Log_Router[Log Router]
                FluentBit[FluentBit]
            end
        end
    end

    subgraph CloudWatch_Logs[CloudWatch Logs]
        LogGroup1[Log Group 1]
        LogGroup2[Log Group 2]
        LogGroup3[Log Group 3]
        LogGroup4[Log Group 4]
        LogGroup5[Log Group 5]
    end

    subgraph Data_Firehose[Data Firehose]
        DataFirehose[Streams]
    end

    subgraph S3_Bucket[S3]
        S3[S3 Bucket]
    end

    Apache -->|logs| FluentBit
    Tomcat -->|logs| FluentBit
    Lambda1 -->|logs| LogGroup3
    Lambda2 -->|logs| LogGroup4
    RDS -->|logs| LogGroup5
    ALB -->|Direct Put| S3
    FluentBit -->|logs| LogGroup1
    FluentBit -->|logs| LogGroup2
    LogGroup1 -->|logs| DataFirehose
    LogGroup2 -->|logs| DataFirehose
    LogGroup3 -->|logs| DataFirehose
    DataFirehose -->|logs| S3

    %% スタイルを追加
    style FluentBit fill:#34495e,color:#ecf0f1
    style Application fill:#34495e,color:#ecf0f1
    style Log_Router fill:#34495e,color:#ecf0f1
    style ECS_Task fill:#34495e,color:#ecf0f1
    style Apache fill:#34495e,color:#ecf0f1
    style Tomcat fill:#34495e,color:#ecf0f1
    style LogGroup1 fill:#34495e,color:#ecf0f1
    style LogGroup2 fill:#34495e,color:#ecf0f1
```

### リソース構成

```mermaid
block-beta
columns 6

Apache1["Apache"] Tomcat1["Tomcat"] FluentBit1["FluentBit"] Apache2["Apache"] Tomcat2["Tomcat"] FluentBit2["FluentBit"]
Fargate1["Fargate"]:3 Fargate2["Fargate"]:3
ECS:6

style FluentBit1 fill:#34495e,color:#ecf0f1
style FluentBit2 fill:#34495e,color:#ecf0f1
```

- サイドカーコンテナとしてECSタスク内で動作する
- ECSタスク定義で設定を行う
- FluentBit自身のログはCloudWatchに転送される

### ログ転送動作

```mermaid
graph LR
    subgraph ECS Task
        subgraph Application Containers
            A[Apache]
            B[Tomcat]
        end
        subgraph FluentBit
            subgraph Inputs
                C[INPUT]
            end
            subgraph Filters
                F1[- FILTER 1<br>- FILTER 2<br>- FILTER 3]
            end
            subgraph Outputs
                O1[OUTPUT 1]
                O2[OUTPUT 2]
            end
        end
    end

    subgraph CloudWatch
        D1[Log Group 1]
        D2[Log Group 2]
    end

    A -->|stdout<br>stderr| C
    B -->|stdout<br>stderr| C
    C --> F1
    F1 -->|rule1<br>matched| O1
    F1 -->|rule2<br>matched| O2
    O1 -->|logs| D1
    O2 -->|logs| D2
```

1. INPUT
   - コンテナが標準出力および標準エラー出力したメッセージを受け取る
2. FILTER
   - ログメッセージを正規表現でマッチングし、出力先を識別するための内部タグを付与する
3. OUTPUT
   - 内部タグに応じた出力先にログを転送する

## 詳細

### INPUT

TODO

### FILTER

TODO

### OUTPUT

TODO

### ヘルスチェック

- FluentBit自身の正常性を確認するためにコンテナのヘルスチェックを実装する
- ヘルスチェック設定は2箇所で行う
  - ECSタスク定義でヘルスチェックのアクションを設定
  - FluentBit側にヘルスチェックに応答するエンドポイントを設定

**参考**
- [health-check-for-fluent-bit](https://docs.fluentbit.io/manual/administration/monitoring#health-check-for-fluent-bit)
- [Fluent Bit FireLens Container Health Check Guidance](https://github.com/aws-samples/amazon-ecs-firelens-examples/tree/mainline/examples/fluent-bit/health-check)

#### 設定
1. ECSタスク定義（taskdef.json）
   - ヘルスチェックセクションに定義
```json
"healthCheck": {
    "command": [
        "CMD-SHELL",
        "curl -f http://127.0.0.1:2020/api/v1/health || exit 1"
    ],
    "interval": 10,
    "timeout": 5,
    "retries": 3,
    "startPeriod": 30
},
```

1. FluentBitカスタムコンフィグ（extra.conf）
   - Serviceセクションに定義

```ini
[SERVICE]
    Flush              1
    Grace              30
    # パーサファイル
    Parsers_File       parsers.conf
    # ヘルスチェック
    HTTP_Server  On
    HTTP_Listen  0.0.0.0
    HTTP_PORT    2020
    Health_Check On
    HC_Errors_Count 5
    HC_Retry_Failure_Count 5
    HC_Period
```

#### 動作

- FluentBit側
  1. `extra.conf`に従い`OUTPUT`の失敗をカウントする
  2. 失敗カウントが閾値を超えるとエラー状態に遷移する
  3. エラー状態の間はエンドポイントにアクセスがあると外部からのアクセスに対してエラーを返す

- ECS側
  1. タスク定義に従いFluentBitコンテナに対してヘルスチェックする
  2. エンドポイントからエラーが返却されるとヘルスチェック失敗となる

## 改修の手引き

