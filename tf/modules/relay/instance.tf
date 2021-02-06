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

resource "aws_security_group" "relay" {
  name    = "${terraform.workspace}-relay-security-group"
  vpc_id  = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = var.relay_node_port
    to_port     = var.relay_node_port
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
    Name = "${terraform.workspace}-cardano-pool-relay"
  }
}

resource "aws_instance" "relay" {
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = var.relay_instance_size
  subnet_id               = var.subnet_id
  vpc_security_group_ids  = [ aws_security_group.relay.id ]

  key_name = var.key_pair_name

  root_block_device {
    volume_size = 30
  }

  tags = {
    Name = "${terraform.workspace}-cardano-pool-relay"
  }
}

resource "aws_eip" "relay" {
  tags = {
    Name = "${terraform.workspace}-cardano-pool-relay"
  }
}

resource "aws_eip_association" "relay" {
  instance_id = aws_instance.relay.id
  allocation_id = aws_eip.relay.id
}