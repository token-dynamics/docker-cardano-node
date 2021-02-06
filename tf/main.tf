provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

module "vpc" {
  source  = "./modules/vpc"
  cidr    = "10.4.0.0/16"
}

module "relay" {
  source              = "./modules/relay"
  relay_instance_size = var.relay_instance_size
  vpc_id              = module.vpc.vpc_id
  subnet_id           = module.vpc.public_subnets[0]
  availability_zone   = module.vpc.zones[0]
}

module "core" {
  source              = "./modules/core"
  core_instance_size  = var.core_instance_size
  vpc_id              = module.vpc.vpc_id
  subnet_id           = module.vpc.private_subnets[0]
}
