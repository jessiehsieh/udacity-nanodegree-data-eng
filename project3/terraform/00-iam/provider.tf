terraform {
  required_version = ">=1.0.11"
  required_providers {
    aws = {
      version = "3.71.0"
    }
  }
}

provider "aws" {
  region  = var.region
  shared_credentials_file = "$HOME/.aws/credentials"
}

terraform {
   backend "s3" {
  }
}