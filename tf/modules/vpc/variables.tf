variable "cidr" {
  description = "The CIDR block to be associated to the VPC"
}

variable "zone" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

locals {
  public_cidrs  = [cidrsubnet(var.cidr, 3, 0), cidrsubnet(var.cidr, 3, 1)]
  private_cidrs = [cidrsubnet(var.cidr, 3, 3), cidrsubnet(var.cidr, 3, 4)]
}