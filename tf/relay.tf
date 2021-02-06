module "relay" {
  source = "./modules/node"

  name          = "relay"
  instance_size = var.relay_instance_size

  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnets[0]
  node_port     = var.relay_node_port
  key_pair_name = var.relay_key_pair_name
}

resource "aws_eip" "relay" {
  tags = {
    Owner = "${terraform.workspace}--cardano-pool"
    Name = "${terraform.workspace}--cardano-pool--relay"
  }
}

resource "aws_eip_association" "relay" {
  instance_id = module.relay.instance_id
  allocation_id = aws_eip.relay.id
}