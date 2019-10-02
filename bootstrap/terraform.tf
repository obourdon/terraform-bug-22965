variable "aws_region" {
  description = "AWS Region"
  default     = "eu-west-1"
}

terraform {
  required_version = "= 0.11.14"

  backend "local" {}
}

provider "aws" {
  version = "= 2.30.0"
  region  = "${var.aws_region}"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_s3_bucket" "terraform_state" {
  lifecycle {
    prevent_destroy = true
  }

  bucket = "s3-${data.aws_caller_identity.current.account_id}-tfstate"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_object" "terraform_state_folder" {
    bucket       = "${aws_s3_bucket.terraform_state.id}"
    acl          = "private"
    key          =  "${var.aws_region}/"
    content_type = "application/x-directory"
}

resource "aws_dynamodb_table" "terraform_locks" {
  name           = "dynamodb-${data.aws_caller_identity.current.account_id}-tflock"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

output "region" {
  value = "${data.aws_region.current.name}"
}

output "bucket" {
  value = "${aws_s3_bucket.terraform_state.id}/${aws_s3_bucket_object.terraform_state_folder.id}"
}

output "dynamodb_table" {
  value = "${aws_dynamodb_table.terraform_locks.name}"
}
