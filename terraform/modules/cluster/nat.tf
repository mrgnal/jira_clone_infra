resource "aws_eip" "this" {}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id = var.alb_subnets[0]
}

resource "aws_route" "this" {
  route_table_id = var.private_rt
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.this.id
}