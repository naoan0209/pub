# aws

## ssm parameter store

### put

aws ssm put-parameter \
  --name "/app/dev/sqs/batch/endpoint" \
  --description "sqs queue endpoint for user notification" \
  --value "https://sqs.ap-northeast-1.amazonaws.com/977566148511/user_notification.fifo" \
  --type String

### get

aws ssm get-parameters \
  --names "/app/dev/sqs/batch/endpoint" \
  --query "Parameters[].Value" \
  --output text

### get with decryption

aws ssm get-parameters \
  --names "/app/dev/batch/key" \
  --with-decryption \
  --query "Parameters[].Value" \
  --output text

#### jsonデータの取り出し
aws ssm get-parameters \
  --names "/app/dev/sample/json_param" \
  --query "Parameters[].Value" \
  --output text

## get all parameters {'Name':$Name, 'Value': $Value}

aws ssm get-parameters-by-path --path "/" --recursive --query "Parameters[].{Name:Name,Value:Value}" --with-decryption
