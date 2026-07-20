data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "rails" {

  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-vpc"
    }
  )
}

resource "aws_internet_gateway" "rails" {

  vpc_id = aws_vpc.rails.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-igw"
    }
  )

}

resource "aws_subnet" "public" {

  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.rails.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-public-${count.index + 1}"
      Tier = "Public"
    }
  )
}

resource "aws_subnet" "private_app" {

  count = length(var.private_app_subnets)

  vpc_id            = aws_vpc.rails.id
  cidr_block        = var.private_app_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-private-app-${count.index + 1}"
      Tier = "Application"
    }
  )
}

resource "aws_subnet" "private_db" {

  count = length(var.private_db_subnets)

  vpc_id            = aws_vpc.rails.id
  cidr_block        = var.private_db_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-private-db-${count.index + 1}"
      Tier = "Database"
    }
  )
}

resource "aws_eip" "nat" {

  domain = "vpc"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-nat-eip"
    }
  )
}

resource "aws_nat_gateway" "rails" {

  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  depends_on = [
    aws_internet_gateway.rails
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-nat"
    }
  )
}

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.rails.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rails.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-public-rt"
    }
  )
}

resource "aws_route_table" "private" {

  vpc_id = aws_vpc.rails.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.rails.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-private-rt"
    }
  )
}

resource "aws_route_table_association" "public" {

  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_app" {

  count = length(aws_subnet.private_app)

  subnet_id      = aws_subnet.private_app[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_db" {

  count = length(aws_subnet.private_db)

  subnet_id      = aws_subnet.private_db[count.index].id
  route_table_id = aws_route_table.private.id
}



