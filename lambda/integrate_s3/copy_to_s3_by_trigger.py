import json
import boto3
import os
from datetime import datetime

# 環境変数から出力先バケットとプレフィックスを取得
OUTPUT_BUCKET_NAME = os.getenv('OUTPUT_BUCKET_NAME')
OUTPUT_BUCKET_PREFIX = os.getenv('OUTPUT_BUCKET_PREFIX')

# S3クライアントの設定
s3 = boto3.client('s3')

def lambda_handler(event, context):
    
    print(json.dumps(event))
    print(event['detail']['object']['key'])
    
    # イベントからソースバケットとキーを取得
    source_bucket = event['detail']['bucket']['name']
    source_key = event['detail']['object']['key']

    # 現在の日付を取得
    now = datetime.now()
    date_path = now.strftime('%Y/%m/%d')

    # 出力先のキーを組み立て
    target_key = f"{OUTPUT_BUCKET_PREFIX}{date_path}/{source_key.split('/')[-1]}"

    # S3からS3へコピー
    copy_source = {
        'Bucket': source_bucket,
        'Key': source_key
    }
    s3.copy(copy_source, OUTPUT_BUCKET_NAME, target_key)

    return {
        'statusCode': 200,
        'body': json.dumps('File copied successfully!')
    }
