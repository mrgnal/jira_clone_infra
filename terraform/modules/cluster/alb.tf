resource "aws_alb" "this" {
    name = var.alb_name
    security_groups = [aws_security_group.alb.id]
    subnets = var.alb_subnets
    enable_deletion_protection = false
}

resource "aws_alb_target_group" "this" {
    name = var.tg_name
    vpc_id = var.vpc_id
    port = var.port
    protocol = var.tg_rotocol
    target_type = var.target_type

    health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
    }
}

resource "aws_alb_listener" "http" {
    count = var.enable_ssl ? 0 : 1

    load_balancer_arn = aws_alb.this.arn
    port              = var.listener_port
    protocol          = "HTTP"

    default_action {
      type             = "forward"
      target_group_arn = aws_alb_target_group.this.arn
    }
}

resource "aws_lb_listener" "https" {
  count = var.enable_ssl ? 1 : 0

  port              = 443
  protocol          = "HTTPS"
  load_balancer_arn = aws_alb.this.arn
  certificate_arn   = var.certificate_arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.this.arn
  }
}