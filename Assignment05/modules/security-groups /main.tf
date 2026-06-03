################################
# Application Load Balancer SG
################################
resource "aws_security_group" "alb" {
  vpc_id = var.vpc_id
  name   = "${var.tags.Environment}-alb-sg"

  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "App access on 8080"
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

  tags = merge(
    var.tags,
    { Name = "${var.tags.Environment}-alb-sg" }
  )
}

################################
# Application EC2 Security Group
################################
resource "aws_security_group" "app" {
  vpc_id = var.vpc_id
  name   = "${var.tags.Environment}-app-sg"

  # Bastion ka SSH rule yahan se delete kar diya hai

  # SSH from Default VPC (Only via Peering)
  ingress {
    description     = "SSH from Default VPC"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = [var.default_vpc_cidr]
  }

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    description     = "App port from ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    { Name = "${var.tags.Environment}-app-sg" }
  )
}
