AWS_PROFILE=dev ./bootstrap/run.sh 2>&1 | tee LOGS/bootstrap.log
AWS_PROFILE=dev ./step1/run.sh 2>&1 | tee LOGS/step1.log
mid=$(AWS_PROFILE=dev aws sts get-caller-identity | jq -r .Account)
AWS_PROFILE=dev aws dynamodb scan --table-name dynamodb-"$mid"-tflock --query "Items[*]" --attributes-to-get LockID | jq --compact-output '.[]' 2>&1 | tee LOGS/dynamodb_entries.log
