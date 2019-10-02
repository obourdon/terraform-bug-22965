#!/bin/bash
set -e

if [ -z "$AWS_PROFILE" ]; then
	echo "Missing AWS_PROFILE variable"
	exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
pushd $DIR

terraform init -backend-config ${DIR}/../backend-${AWS_PROFILE}.tfvars
terraform apply

popd
