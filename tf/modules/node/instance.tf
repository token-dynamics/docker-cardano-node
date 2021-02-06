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

resource "aws_security_group" "node" {
  name    = "${terraform.workspace}--${var.name}"
  vpc_id  = var.vpc_id

  ingress {
    description = "Node connection from VPC"
    from_port   = var.node_port
    to_port     = var.node_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from VPC"
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
    Owner = "${terraform.workspace}--cardano-pool" 
    Name = "${terraform.workspace}--cardano-pool--${var.name}"
  }
}

resource "aws_instance" "node" {
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = var.instance_size
  subnet_id               = var.subnet_id
  vpc_security_group_ids  = [ aws_security_group.node.id ]

  user_data = templatefile(
    "${path.module}/user_data/init-install.sh",
    {}
  )

  key_name = var.key_pair_name

  root_block_device {
    volume_size = var.volume_size
  }

  tags = {
    Owner = "${terraform.workspace}--cardano-pool" 
    Name = "${terraform.workspace}--cardano-pool--${var.name}"
  }
}