# ECS Exec

コンテナ内に入る機能

機能を有効にする必要がある
- サービス 作成時 に有効にする
- サービス 作成後 に有効にする

サービス作成後の場合は以下のコマンドを実行、タスクを再デプロイする必要がある

aws ecs update-service \
    --cluster web\
    --service tomcat\
    --enable-execute-command | grep enableExecuteCommand

aws ecs describe-services \
--cluster web \
--services tomcat | grep enableExecuteCommand

TASK_ARN=$(aws ecs list-tasks --cluster web --query "taskArns[]"  --output text)

aws ecs execute-command --cluster web \
    --task ${TASK_ARN} \
    --container tomcat \
    --interactive \
    --command "/bin/sh"
