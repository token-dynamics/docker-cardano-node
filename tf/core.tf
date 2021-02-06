module "core" {
  source = "./modules/node"

  name          = "core"
  instance_size = var.core_instance_size

  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.private_subnets[0]
  node_port     = var.core_node_port
  key_pair_name = var.core_key_pair_name
}