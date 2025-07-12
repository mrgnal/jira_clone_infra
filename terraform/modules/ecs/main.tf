resource "aws_ecs_cluster" "this" {
    name = var.cluster_name

    setting {
        name  = "containerInsights"
        value = var.container_metric
    }
}

resource "aws_ecs_service" "this" {
    name = "staging-app-service"
    cluster = aws_ecs_cluster.this.id
    task_definition = var.task_definition
    desired_count = var.desired_count
    launch_type = var.desired_count
    force_new_deployment = var.force_new_deployment

    load_balancer {
      target_group_arn = var.target_group_arn
      container_port = var.container_port
      container_name = var.container_name
    }

    network_configuration {
      assign_public_ip = var.assign_public_ip
      subnets = [for id in var.subnets_ids : id]
      security_groups = [for id in var.security_groups : id]
    }
}
