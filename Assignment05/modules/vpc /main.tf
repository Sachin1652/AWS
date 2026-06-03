################################
# Availability Zones
################################
data "aws_availability_zones" "available" {
  state = "available"
}

################################
# VPC
################################
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.tags,
    { Name = "${var.tags.Environment}-vpc" }
  )
}

################################
# Internet Gateway
################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    { Name = "${var.tags.Environment}-igw" }
  )
}

################################
# Public Subnets (AZ-wise)
################################
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.tags.Environment}-public-Subnet-${count.index == 0 ? "01" : "02"}"
    }
  )
}

################################
# Private Subnets (AZ-wise)
################################
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    var.tags,
    {
      Name = "${var.tags.Environment}-private-Subnet-${count.index == 0 ? "01" : "02"}"
    }
  )
}

################################
# NAT Gateway (Single – Cost Optimized)
################################
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(
    var.tags,
    { Name = "${var.tags.Environment}-nat-eip" }
  )
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.tags,
    { Name = "${var.tags.Environment}-NAT-gw" }
  )

  depends_on = [aws_internet_gateway.igw]
}

################################
# Public Route Table
################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    var.tags,
    { Name = "${var.tags.Environment}-public-rt" }
  )
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

################################
# Private Route Table
################################
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(
    var.tags,
    { Name = "${var.tags.Environment}-private-rt" }
  )
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
