terraform {
  required_version = "= 0.14.3"

  backend "s3" {
    bucket  = "token-dynamics-tfstate"
    key     = "tfstate"
    region  = "ap-southeast-2"
    profile = "token-dynamics"
    encrypt = true
    # dynamodb_table = "token-dynamics-tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }

    external = {
      source = "hashicorp/external"
      version = "2.0.0"
    }
  }
}

