AWS Cloud Map API の `discover_instances` メソッドを使用して特定のサービスに登録されているインスタンスを検索する場合、一度に取得できるインスタンスの数には上限があります。この上限は API の `MaxResults` パラメータで指定できますが、一度の API 呼び出しで取得できる最大数には制限があり、すべてのインスタンスを一度に取得することができない場合があります。

すべてのインスタンスを取得するには、応答に `NextToken` が含まれている場合（つまり、さらに取得すべきデータがある場合）、その `NextToken` を使用して追加の API 呼び出しを行い、残りのインスタンスを取得する必要があります。これをページング処理と呼びます。

以下は、`NextToken` を使用して Cloud Map からすべてのインスタンスを取得するための改善されたサンプルコードです。

```python
import boto3

def discover_all_instances(namespace_name, service_name, health_status='HEALTHY'):
    client = boto3.client('servicediscovery')
    instances = []
    next_token = None

    # ページング処理を使用してすべてのインスタンスを取得
    while True:
        if next_token:
            response = client.discover_instances(
                NamespaceName=namespace_name,
                ServiceName=service_name,
                MaxResults=100,  # MaxResults の最大値を指定
                HealthStatus=health_status,
                NextToken=next_token
            )
        else:
            response = client.discover_instances(
                NamespaceName=namespace_name,
                ServiceName=service_name,
                MaxResults=100,  # MaxResults の最大値を指定
                HealthStatus=health_status
            )
        
        instances.extend(response['Instances'])

        # 'NextToken' が応答に含まれていなければ、すべてのインスタンスを取得したことになる
        next_token = response.get('NextToken')
        if not next_token:
            break

    return instances

# 使用例
namespace_name = 'example.com'
service_name = 'your-service'
all_instances = discover_all_instances(namespace_name, service_name)

for instance in all_instances:
    print(f"Instance ID: {instance['InstanceId']}, IP: {instance['Attributes']['AWS_INSTANCE_IPV4']}")
```

このコードは、`discover_instances` メソッドをループ内で繰り返し呼び出し、`NextToken` を使用してページング処理を行い、すべてのインスタンスを取得します。これにより、指定したサービスに登録されているすべてのインスタンスの情報を取得できます。

`MaxResults` の値は API によって異なる場合があるため、最大値は AWS のドキュメントを参照して適切に設定してください。
