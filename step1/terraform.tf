terraform {
  required_version = "= 0.11.14"

  backend "s3" {
    key     = "step1.tfstate"
    encrypt = true

    workspace_key_prefix = "step1"
  }
}

provider "aws" {
  version = "= 2.30.0"
  region  = "${var.aws_region}"
}
