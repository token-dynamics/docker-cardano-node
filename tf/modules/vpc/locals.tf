data aws_region "current" {}

locals {
  public_cidrs  = [cidrsubnet(var.cidr, 3, 0), cidrsubnet(var.cidr, 3, 1)]
  private_cidrs = [cidrsubnet(var.cidr, 3, 3), cidrsubnet(var.cidr, 3, 4)]

  zone = ["${data.aws_region.current.name}a", "${data.aws_region.current.name}b"]
}