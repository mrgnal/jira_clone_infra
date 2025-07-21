resource "aws_security_group" "lambda" {
  vpc_id = var.vpc_id
  name = "lambda-sg"
  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = var.subnets_cidr
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}