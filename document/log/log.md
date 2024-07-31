# ログ基本設計

**親ページ**

| 内容 | Markdownリンク | HTMLリンク |
|---|---|---|
| サイトマップ | [md](../sitemap.md) | <a href="../sitemap.html">html</a> |

**目次**
- [ログ基本設計](#ログ基本設計)
  - [全体像](#全体像)
    - [ライフサイクル](#ライフサイクル)
    - [運用](#運用)
      - [ログの確認](#ログの確認)
  - [FluentBit](#fluentbit)

## 全体像

### ライフサイクル

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
```

```mermaid
graph LR
    subgraph S3
        E[Bucket Standard Class]
    end

    subgraph Glacier
        F[Bucket Glacier Class]
    end

    G[Deleted Logs]

    E -->|after retention period| F
    F -->|after extended retention period| G
```

- 基本的な流れ
  1. アプリケーションやAWSサービスがCloudWatchにログを出力する
     - AWSサービスは直接S3に出力する場合もある
  2. CloudWatchからData Firehoseを経由してS3にログを転送する
  3. S3はライフサイクルに従い、一定期間経過したログをGlacierにアーカイブする
  4. Glacierは一定期間経過したログを削除する

### 運用

#### ログの確認
  1. CloudWatch Logs
     - 運用オペレーションにおいてはログの確認は基本的にCloudWatchから行う
     - GUIやLogs Insights等の高機能なログ管理機能が提供されている
     - コストが高いため長期間の保存には適さず、CloudWatch上のログは数ヶ月でローテーションする
  2. S3
     - 最終的にすべてのログはS3に格納される
     - CloudWatchでのローテーション後のログを確認できる
     - アプリケーションでログ集計するケースではCloudWatchではなくS3に保管されたログを参照する
     - Javaアプリケーションはログが構造化されていないためAthenaは利用できない

## FluentBit

[FluentBit](./fluentbit.md)
