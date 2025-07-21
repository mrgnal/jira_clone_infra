resource "aws_appautoscaling_target" "this" {
    max_capacity       = var.max_capacity
    min_capacity       = var.min_capacity
    resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"
    scalable_dimension = "ecs:service:DesiredCount"
    service_namespace  = "ecs"
  }

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
    name               = var.autoscale_policy_name
    policy_type        = "TargetTrackingScaling"
    resource_id        = aws_appautoscaling_target.this.resource_id
    scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
    service_namespace  = aws_appautoscaling_target.this.service_namespace

    target_tracking_scaling_policy_configuration {
      target_value       = var.target_value
      predefined_metric_specification {
        predefined_metric_type = "ECSServiceAverageCPUUtilization"
      }
          scale_in_cooldown  = var.scale_cooldown
          scale_out_cooldown = var.scale_cooldown
        }
}