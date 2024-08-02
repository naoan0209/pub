# nginx

## 構成

```mermaid
graph LR
    subgraph LocalPC1["Local PC"]
        BROWSER1[Browser]
        SSM1[Session Manager<br>localhost:8080]
        BROWSER1 --> SSM1
    end

    subgraph LocalPC2["Local PC"]
        BROWSER2[Browser]
        SSM2[Session Manager<br>localhost:8081]
        BROWSER2 --> SSM2
    end

    subgraph LocalPC3["Local PC"]
        BROWSER3[Browser]
        SSM3[Session Manager<br>localhost:8082]
        BROWSER3 --> SSM3
    end

    SSM1 --> |forward:8080| 開発用サーバ
    SSM2 --> |forward:8081| 開発用サーバ
    SSM3 --> |forward:8082| 開発用サーバ

    subgraph AWS["AWS"]
        subgraph 開発用サーバ["開発用サーバ"]
            subgraph DockerCompose["docker compose"]
                subgraph Nginx["nginx"]
                    8080conf[8080.conf]
                    8081conf[8081.conf]
                    8082conf[8082.conf]
                end
            end
        end
        subgraph ALB["ALB"]
            Listener1[Listener1]
            Listener2[Listener2]
            Listener3[Listener3]
        end
        subgraph ECS["ECS"]
            WebApp1["WebApp1"]
            WebApp2["WebApp2"]
            WebApp3["WebApp3"]
        end

        開発用サーバ --> |proxy_pass:8080| Listener1
        開発用サーバ --> |proxy_pass:8081| Listener2
        開発用サーバ --> |proxy_pass:8082| Listener3
        Listener1 --> WebApp1
        Listener2 --> WebApp2
        Listener3 --> WebApp3
    end
```

## 使い方

1. Session Managerでポートフォワーディングを実行
2. フォワードしたポートにブラウザ等からアクセス
3. nginxとALBを経由してターゲットにリクエストが届く

### 詳細

- ポート番号は各メンバーに割り当てます
- ポート番号ごとの設定を`XXXX.conf`で変更できます
  - デフォルトはnginx自身と同じポートのALBリスナーに転送

### nginx側の設定変更

1. vi等で`XXXX.conf`を編集
2. `docker container exec -it nginx nginx -s reload`を実行
   - 安全にファイル更新を適用する


## 管理者向け

### ディレクトリ構成

<pre>
├── setup
│   └── setup_docker_and_compose.sh
├── conf
│   └── nginx.conf
├── conf.d
│   ├── sites
│   │   ├── port_8080.conf
│   │   ├── port_8081.conf
│   │   └── port_8082.conf
│   │   └── port_XXXX.conf
│   └── variables.conf
├── docker-compose.yml
├── Dockerfile
└── README.md
</pre>

- setup
  - dockerおよびdocker composeをインストールするスクリプト
- conf/nginx.conf
  - proxy_passをホスト名で設定しているため、resolverを定義している
- conf.d/variables.conf
  - 全体に適用したい共通の環境変数を定義する
  - ALBのホスト名はここで定義する
- conf.d/sites/portXXXX.conf
  - nginxがListenするポートごとにファイルを作成する
  - 開発メンバーごとにポートを払い出す運用を想定
