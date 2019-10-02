#!/bin/bash
set -e

if [ -z "$AWS_PROFILE" ]; then
	echo "Missing AWS_PROFILE variable"
	exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
pushd $DIR

terraform init -backend-config path=terraform-${AWS_PROFILE}.tfstate
terraform apply
terraform output 2>/dev/null | tr -d '\r' | sed -e 's/= /= "/; s/$/"/' >../backend-${AWS_PROFILE}.tfvars

popd
