provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

module "vpc" {
    source = "./modules/vpc"

    cidr = "10.4.0.0/16"
}