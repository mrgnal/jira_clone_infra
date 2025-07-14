resource "aws_cloudwatch_event_rule" "this" {
  name = var.event_rule_name
  event_pattern = var.event_pattern
}

resource "aws_ecs_task_definition" "this" {
    family = var.family_name
    network_mode = var.network_mode
    execution_role_arn = aws_iam_policy.this.arn
    cpu = var.cpu
    memory = var.memory
    requires_compatibilities = ["FARGATE"]
    container_definitions = var.container_definitions
}

resource "aws_cloudwatch_event_target" "this" {
  rule = aws_cloudwatch_event_rule.this.name
  target_id = var.target_id
  arn = var.cluster_arn

  ecs_target {
    task_definition_arn = aws_ecs_task_definition.this.arn
    launch_type         = "FARGATE"
     network_configuration {
      subnets          = var.private_subnets
      assign_public_ip = false
      security_groups  = var.security_groups
    }
  }
}