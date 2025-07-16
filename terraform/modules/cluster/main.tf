resource "aws_ecs_cluster" "this" {
    name = var.cluster_name

    setting {
        name  = "containerInsights"
        value = var.container_metric
    }
}

resource "aws_ecs_service" "this" {
    name = var.service_name
    cluster = aws_ecs_cluster.this.id
    task_definition = aws_ecs_task_definition.this.id
    desired_count = var.desired_count
    launch_type = var.launch_type
    force_new_deployment = var.force_new_deployment

    load_balancer {
      target_group_arn = aws_alb_target_group.this.arn
      container_port = var.port
      container_name = var.container_name
    }

    network_configuration {
      assign_public_ip = var.assign_public_ip
      subnets = var.ecs_subnets
      security_groups = var.ecs_sg
    }
}

resource "aws_ecs_task_definition" "this" {
    family = var.family_name
    network_mode = var.network_mode
    execution_role_arn = aws_iam_role.this.arn
    cpu = var.cpu
    memory = var.memory
    requires_compatibilities = ["FARGATE"]
    container_definitions = var.container_definitions
}