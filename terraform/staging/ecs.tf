resource "aws_ecs_cluster" "app_cluster" {
  name = "jira-cluster"
    setting {
    name  = "containerInsights"
    value = "disabled"
    }
}
