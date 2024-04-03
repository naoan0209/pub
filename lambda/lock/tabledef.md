$ aws dynamodb describe-table --table-name batch-lock
{
    "Table": {
        "AttributeDefinitions": [
            {
                "AttributeName": "batch-id",
                "AttributeType": "S"
            }
        ],
        "TableName": "batch-lock",
        "KeySchema": [
            {
                "AttributeName": "batch-id",
                "KeyType": "HASH"
            }
        ],
        "TableStatus": "ACTIVE",
        "CreationDateTime": "2024-03-31T12:30:30.552000+09:00",
        "ProvisionedThroughput": {
            "NumberOfDecreasesToday": 0,
            "ReadCapacityUnits": 1,
            "WriteCapacityUnits": 1
        },
        "TableSizeBytes": 0,
        "ItemCount": 0,
        "TableArn": "arn:aws:dynamodb:ap-northeast-1:977566148511:table/batch-lock",
        "TableId": "f2ff0647-c3db-4faf-9f3b-52ec9b643a55",
        "TableClassSummary": {
            "TableClass": "STANDARD_INFREQUENT_ACCESS"
        },
        "DeletionProtectionEnabled": false
    }
}
