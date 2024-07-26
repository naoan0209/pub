# Fluent Bit

## ファイル構成

fluentbit
├── README.md
├── Dockerfile
└── conf
    ├── java
    │   ├── extra.conf
    │   └── parsers.conf
    ├── python
    └── shell

## ビルド方法

### マルチステージビルド

- 環境変数TYPEを指定し、ビルド時に読み取るコンフィグを選択
- TYPEには以下のいずれかの文字列で指定
  - "Java"
  - "Shell"
  - "Python"
  - 
`docker build --target ${TYPE} -t fluent-bit:${TYPE}`
