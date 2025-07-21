output "public_subnets_ids" {
  value = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnets_ids" {
  value = [for subnet in aws_subnet.private : subnet.id]
}

output "private_subnets_cidr" {
  value = [for subnet in aws_subnet.private : subnet.cidr_block]
}

# output "alb_sg_id" {
#   value = aws_security_group.alb.id
# }

# output "ecs_sg_id" {
#   value = aws_security_group.ecs.id
# }

# output "rds_sg_id" {
#   value = aws_security_group.rds.id
# }

# output "endpoint_sg_id" {
#   value = aws_security_group.endpoint.id
# }

output "vpc_id" {
  value = aws_vpc.this.id
}

output "private_rt" {
  value = aws_route_table.private.id
}

output "public_rt" {
  value = aws_route_table.public.id
}