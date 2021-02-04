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

}

resource "aws_instance" "relay" {
  ami             = "ami-07fbdcfe29326c4fb"
  instance_type   = var.relay_instance_size
  subnet_id       = var.subnet_id
  security_groups = [ aws_security_group.relay.id ]

  tags = {
    Name = "${terraform.workspace}-cardano-pool-relay"
  }
}