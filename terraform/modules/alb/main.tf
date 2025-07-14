resource "aws_alb" "this" {
    name = var.alb_name
    security_groups = var.security_groups_ids
    subnets = var.subnets_ids
    enable_deletion_protection = false
}

resource "aws_alb_listener" "this" {
    load_balancer_arn = aws_alb.this.arn
    port              = var.listener_port
    protocol          = var.listener_rotocol

    default_action {
      type             = "forward"
      target_group_arn = aws_alb_target_group.this.arn
    }
}

resource "aws_alb_target_group" "this" {
    name = var.tg_name
    vpc_id = var.vpc_id
    port = var.tg_port
    protocol = var.tg_rotocol
    target_type = var.target_type
}