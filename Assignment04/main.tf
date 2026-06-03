################################
# DATA SOURCES
################################
data "aws_availability_zones" "available" { state = "available" }

data "aws_route53_zone" "this" {
  name         = var.domain_name
  private_zone = false
}

################################
# NETWORK (VPC, Subnets, IGW, NAT)
################################
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.tags, { Name = "${var.tags.Environment}-vpc" })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.tags.Environment}-igw" })
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = merge(var.tags, { Name = "${var.tags.Environment}-public-0${count.index+1}" })
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge(var.tags, { Name = "${var.tags.Environment}-private-0${count.index+1}" })
}

resource "aws_eip" "nat" { domain = "vpc" }

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  depends_on    = [aws_internet_gateway.igw]
}

################################
# ROUTING
################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(
    var.tags,
    {
      Name = "${var.tags.Environment}-public-rt"
    }
  )
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = merge(
    var.tags,
    {
      Name = "${var.tags.Environment}-private-rt"
    }
  )
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

################################
# SECURITY GROUPS
################################
resource "aws_security_group" "alb" {
  vpc_id = aws_vpc.this.id
  name   = "${var.tags.Environment}-alb-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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

resource "aws_security_group" "app" {
  vpc_id = aws_vpc.this.id
  name   = "${var.tags.Environment}-app-sg"

  ingress {
    description = "SSH via Peering"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.default_vpc_cidr]
  }

  ingress {
    description     = "Traffic from ALB"
    from_port       = 80
    to_port         = 8080 # Dynamic range or specific ports
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

################################
# COMPUTE (EC2)
################################
resource "aws_instance" "app" {
  count                  = length(aws_subnet.private)
  ami                    = var.ubuntu_ami_id
  instance_type          = var.instance_type1
  subnet_id              = aws_subnet.private[count.index].id
  vpc_security_group_ids = [aws_security_group.app.id]
  key_name               = var.key_name
  tags = merge(var.tags, { Name = "${var.tags.Environment}-app-${count.index}" })
}

################################
# LOAD BALANCER (ALB)
################################
resource "aws_lb" "main" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id
}

resource "aws_lb_target_group" "tg_80" {
  name     = var.tg_80_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id
}

resource "aws_lb_target_group_attachment" "tg_80_attach" {
  count            = length(aws_instance.app)
  target_group_arn = aws_lb_target_group.tg_80.arn
  target_id        = aws_instance.app[count.index].id
}

resource "aws_lb_listener" "http_80" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_80.arn
  }
}

################################
# ROUTE53
################################
resource "aws_route53_record" "root" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}

################################
# VPC PEERING
################################
resource "aws_vpc_peering_connection" "this" {
  vpc_id      = aws_vpc.this.id
  peer_vpc_id = var.default_vpc_id
  auto_accept = true
}

resource "aws_route" "peering_route" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = var.default_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}