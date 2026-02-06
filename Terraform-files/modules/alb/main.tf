#===== secutiy group for ALB =====#
resource "aws_security_group" "alb_sg" {
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

#===== Application Load Balancer =====#
resource "aws_lb" "this" {
    name = "${var.env}-alb"
    load_balancer_type = "application"
    security_groups = [ aws_security_group.alb_sg.id ]
    subnets = var.public_subnet_ids

    tags = {
        Name = "${var.env}-application-load-balancer"
    }
}

#===== Target Group for ALB =====#
resource "aws_lb_target_group" "tg" {
    name = "${var.env}-tg"
    port = 1337
    protocol = "HTTP"
    vpc_id = var.vpc_id
    health_check {
      path = "/"
    }
}

#===== register EC2 instance with target group =====#
resource "aws_lb_target_group_attachment" "ec2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.ec2_instance_id
  port             = 1337
}

#===== Listener for ALB =====#
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
