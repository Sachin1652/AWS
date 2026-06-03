################################
# Application Load Balancer
################################
resource "aws_lb" "this" {
  name               = var.alb_name
  load_balancer_type = "application"
  internal           = false

  subnets         = var.public_subnet_ids
  security_groups = [var.alb_sg_id]

  tags = merge(
    var.tags,
    { Name = var.alb_name }
  )
}

################################
# Target Group - Port 80
################################
resource "aws_lb_target_group" "tg_80" {
  name     = var.tg_80_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path    = "/"
    matcher = "200"
  }

  tags = merge(
    var.tags,
    { Name = var.tg_80_name }
  )
}

################################
# Target Group - Port 8080
################################
resource "aws_lb_target_group" "tg_8080" {
  name     = var.tg_8080_name
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path    = "/"
    port    = "8080"
    matcher = "200"
  }

  tags = merge(
    var.tags,
    { Name = var.tg_8080_name }
  )
}

################################
# Attach EC2s to TG (80)
################################
resource "aws_lb_target_group_attachment" "app_80" {
  count            = length(var.target_instance_ids)
  target_group_arn = aws_lb_target_group.tg_80.arn
  target_id        = var.target_instance_ids[count.index]
  port             = 80
}

################################
# Attach EC2s to TG (8080)
################################
resource "aws_lb_target_group_attachment" "app_8080" {
  count            = length(var.target_instance_ids)
  target_group_arn = aws_lb_target_group.tg_8080.arn
  target_id        = var.target_instance_ids[count.index]
  port             = 8080
}

################################
# Listener - Port 80
################################
resource "aws_lb_listener" "http_80" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_80.arn
  }
}

################################
# Listener - Port 8080
################################
resource "aws_lb_listener" "http_8080" {
  load_balancer_arn = aws_lb.this.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_8080.arn
  }
}
################################
