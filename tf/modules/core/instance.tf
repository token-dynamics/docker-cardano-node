data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu-minimal/images/hvm-ssd/ubuntu-focal-20.04-amd64-minimal-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "core" {
  name    = "${terraform.workspace}-core-security-group"
  vpc_id  = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = var.core_node_port
    to_port     = var.core_node_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${terraform.workspace}-cardano-pool-core"
  }

}

resource "aws_instance" "core" {
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = var.core_instance_size
  subnet_id               = var.subnet_id
  vpc_security_group_ids  = [ aws_security_group.core.id ]

  key_name = var.key_pair_name

  root_block_device {
    volume_size = 30
  }

  tags = {
    Name = "${terraform.workspace}-cardano-pool-core"
  }
}