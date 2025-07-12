resource "aws_ecs_task_definition" "this" {
    family = var.family_name
    network_mode = var.network_mode
    execution_role_arn = var.execution_role_arn
    cpu = var.cpu
    memory = var.memory
    requires_compatibilities = ["FARGATE"]
    container_definitions = var.container_definitions
}