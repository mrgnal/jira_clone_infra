#ALB
resource "aws_security_group" "alb" {
  vpc_id = aws_vpc.this.id
  name = "ald_sg"
  ingress {
    from_port = 80
    to_port = 80
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
  vpc_id = aws_vpc.this.id
  name = "ecs_sg"
  ingress {
    from_port = 3000
    to_port = 3000
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

#RDS
resource "aws_security_group" "rds" {
  vpc_id = aws_vpc.this.id
  name = "rds_sg"
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Endpoints
# resource "aws_security_group" "endpoint" {
#   vpc_id = aws_vpc.this.id
#   name = "endpoints_sg"
#   ingress {
#     from_port = 443
#     to_port = 443
#     protocol = "tcp"
#     security_groups = [aws_security_group.ecs.id]
#   }

#   egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }