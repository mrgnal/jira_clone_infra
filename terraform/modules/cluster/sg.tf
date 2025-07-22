#ALB
resource "aws_security_group" "alb" {
  vpc_id = var.vpc_id
  name = "ald_sg"

  ingress { 
    from_port = var.enable_ssl ? 443 : 80
    to_port = var.enable_ssl ? 443 : 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#ECS 
resource "aws_security_group" "ecs" {
  vpc_id = var.vpc_id
  name = "ecs_sg"
  ingress {
    from_port = var.port
    to_port = var.port
    protocol = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}