"""
DynamoDBにロックアイテムを作成する
API Gatewayからの呼び出し想定版

Lambdaに直接イベントjsonを渡して実行する際は次の形式
{"body": "{\"batchId\": \"clean-db\", \"ttl\": 10}"}
"""
import json
import time

import boto3
from botocore.exceptions import ClientError

# DynamoDBのクライアントを作成
dynamodb_client = boto3.client('dynamodb')
table_name = "batch-lock"

def lambda_handler(event, context):
    try:
        ret = main(event, context)
    except Exception as e:
        # 予期せぬエラーのキャッチとログ出力
        print(f"Unexpected error: {str(e)}")
        # API Gatewayに返すエラーメッセージをより説明的に
        return {
            'statusCode': 500,
            'body': json.dumps({"message": "Internal server error. Please contact the system administrator."})
        }
    return {
        'statusCode': ret["statusCode"],
        'body': ret["body"]
    }

def check_record_expiration(batch_id):
    now = int(time.time())
    try:
        response = dynamodb_client.get_item(
            TableName=table_name,
            Key={"batch-id": {"S": batch_id}},
            ProjectionExpression="#expire_at",
            ExpressionAttributeNames={"#expire_at": "expire-at"},  # 実際の属性名にマッピング
        )
        item = response.get("Item")
        if item and int(item["expire-at"]["N"]) > now:
            return False  # 有効期限内なので新しいバッチを開始しない
        return True  # レコードが存在しないか有効期限が切れている
    except ClientError as e:
        error_message = e.response["Error"]["Message"]
        print(f"DynamoDB ClientError on check_record_expiration: {error_message}")
        raise Exception(f"Failed to check record expiration for batch_id {batch_id}: {error_message}")

def create_batch_record_with_exclusive_control_and_time_info(batch_id, ttl_seconds):
    now = int(time.time())
    expiration_time = now + ttl_seconds

    if not check_record_expiration(batch_id):
        return {
            "statusCode": 409,
            "body": json.dumps({
                "message": "The batch is currently in progress or an error occurred while checking the record.",
                "current_time": now,
                "expected_expiration_time": "N/A",
            }),
        }

    try:
        dynamodb_client.put_item(
            TableName=table_name,
            Item={
                "batch-id": {"S": batch_id},
                "status": {"S": "Processing"},
                "register-at": {"N": str(now)},
                "expire-at": {"N": str(expiration_time)},
            },
            ConditionExpression="attribute_not_exists(#batch_id) OR #expire_at < :now",
            ExpressionAttributeNames={
                "#batch_id": "batch-id",  # ハイフンを含む属性名のマッピング
                "#expire_at": "expire-at",  # ハイフンを含む属性名のマッピング
            },
            ExpressionAttributeValues={
                ":now": {"N": str(now)},
            },
        )
        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "Batch record created or updated successfully.",
                "current_time": now,
                "expiration_time": expiration_time,
            }),
        }
    except ClientError as e:
        if e.response["Error"]["Code"] == "ConditionalCheckFailedException":
            message = "The batch is currently in progress, or the condition check failed."
        else:
            message = f"Failed to create or update batch record: {e.response['Error']['Message']}"
        print(message)
        return {
            "statusCode": 400,
            "body": json.dumps({
                "message": message,
                "current_time": now,
                "expected_expiration_time": "N/A",
            }),
        }

def main(event, context):
    try:
        req = json.loads(event["body"])
        batch_id = req["batchId"]
        ttl = req["ttl"]
        print(event)
        response = create_batch_record_with_exclusive_control_and_time_info(batch_id, ttl_seconds=ttl)
        print(response)
        return response
    except json.JSONDecodeError as e:
        print(f"JSON decoding error: {str(e)}")
        raise Exception("Failed to decode JSON payload.")
