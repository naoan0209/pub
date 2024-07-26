# Fluent Bit

## 最新のstableを確認するコマンド
aws ssm get-parameters \
    --names /aws/service/aws-for-fluent-bit/stable \
    --region ap-northeast-1

### マルチステージビルド

- 環境変数TYPEを指定し、ビルド時に読み取るコンフィグを選択
- TYPEには以下のいずれかの文字列で指定
  - "Java"
  - "Shell"
  - "Python"
  - 
`docker build --target ${TYPE} -t fluent-bit:${TYPE}`
