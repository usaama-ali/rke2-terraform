terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.25.0"
    }
  }
  required_version = ">= 1.6.3"
}

provider "aws" {
  shared_config_files      = ["/home/emumba/.aws/config"]
  shared_credentials_files = ["/home/emumba/.aws/credentials"]
  profile                  = "default"
}