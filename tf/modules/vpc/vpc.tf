resource "aws_vpc" "main" {
  cidr_block = var.cidr

  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${terraform.workspace}-cardano-pool"
  }
}

resource "aws_subnet" "public" {
  count             = length(local.public_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.public_cidrs[count.index]
  availability_zone = local.zone[count.index]

  map_public_ip_on_launch = true

  tags  = {
    Name = "${terraform.workspace}-cardano-pool-public-${local.zone[count.index]}"
    Type = "public"
  }
}

resource "aws_subnet" "private" {
  count             = length(local.private_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_cidrs[count.index]
  availability_zone = local.zone[count.index]

  tags  = {
    Name = "cardano-pool-private-${terraform.workspace}-${local.zone[count.index]}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${terraform.workspace}-cardano-pool"
  }
}

resource "aws_eip" "nat" {
  count    = length(local.private_cidrs)
  vpc      = true
}

resource "aws_nat_gateway" "nat" {
  count         = length(local.private_cidrs)

  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  tags = {
    Name = "${terraform.workspace}-cardano-pool-${count.index}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count          = length(local.public_cidrs)

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count  = length(local.private_cidrs)
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "private" {
  count                   = length(local.private_cidrs)

  route_table_id          = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id          = element(aws_nat_gateway.nat.*.id, 0)
}

resource "aws_route_table_association" "private" {
  count          = length(local.private_cidrs)

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
