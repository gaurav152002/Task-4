#===== secutiy group for ALB =====#
resource "aws_security_group" "alb_sg" {
  name        = "${var.env}-alb-sg"
  description = "ALB security group"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "${var.env}-alb-sg"
  }
}

# ===== Application Load Balancer =====
resource "aws_lb" "alb" {
  name               = "${var.env}-alb"
  load_balancer_type = "application"
  internal           = false

  security_groups = [aws_security_group.alb_sg.id]
  subnets         = var.public_subnet_ids

  tags = {
    Name = "${var.env}-alb"
  }
}

# ===== Target Group for Strapi EC2 =====
resource "aws_lb_target_group" "strapi_tg" {
  name     = "${var.env}-tg"
  port     = 1337
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  # Health check configuration
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.env}-tg"
  }
}


# ===== Register EC2 with Target Group =====
resource "aws_lb_target_group_attachment" "ec2_attach" {
  target_group_arn = aws_lb_target_group.strapi_tg.arn
  target_id        = var.ec2_instance_id
  port             = 1337
}

# ===== ALB Listener (HTTP 80 → Strapi TG) =====
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.strapi_tg.arn
  }
}

