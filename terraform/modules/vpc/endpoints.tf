resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id = aws_vpc.this.id
  service_name = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [aws_route_table.private.id]
}

locals {
services = {
    "ec2messages" : {
        "name" : "com.amazonaws.${var.region}.ec2messages"
    },
    "ssm" : {
        "name" : "com.amazonaws.${var.region}.ssm"
    },
    "ssmmessages" : {
        "name" : "com.amazonaws.${var.region}.ssmmessages"
    }

    "dkr" : {
        "name" : "com.amazonaws.${var.region}.ecr.dkr"
    }
    "ecs-telemetry" : {
        "name" : "com.amazonaws.${var.region}.ecs-telemetry"
    }
    "ecs-agent" : {
        "name" : "com.amazonaws.${var.region}.ecs-agent"
    }
    "api" : {
        "name" : "com.amazonaws.${var.region}.ecr.api"
    }
    }
}

resource "aws_vpc_endpoint" "endpoints_for_ecs" {
    for_each = local.services
    vpc_id   = aws_vpc.this.id
    service_name        = each.value.name
    vpc_endpoint_type   = "Interface"
    security_group_ids  = [var.endpoint_sg_id]
    private_dns_enabled = true
    ip_address_type     = "ipv4"
    subnet_ids          = [for subnet in aws_subnet.private : subnet.id]
}