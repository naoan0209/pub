CLUSTER_NAME="batch"
FAMILY_NAME="batch"
SUBNET_ID="subnet-0608d5771aa3cd3e8"
SG_ID="sg-00488bc0199daf19b"

TASK_DEF_ARN=$(aws ecs list-task-definitions \
  --family-prefix "${FAMILY_NAME}" \
  --query "reverse(taskDefinitionArns)[0]" \
  --output text)

aws ecs run-task --cluster "${CLUSTER_NAME}" \
  --launch-type FARGATE \
  --task-definition "${TASK_DEF_ARN}" \
  --count 1 \
  --network-configuration "awsvpcConfiguration={subnets=[${SUBNET_ID}],securityGroups=[${SG_ID}],assignPublicIp=ENABLED}"
