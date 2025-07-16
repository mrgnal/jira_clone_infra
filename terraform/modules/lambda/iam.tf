resource "aws_iam_role" "execution_role" {
    name = var.role_name

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Principal = {
              Service = "ecs-tasks.amazonaws.com"
            }
            Action = "sts:AssumeRole"
          }
        ]
      })
}

resource "aws_iam_policy" "this" {
    for_each = { for p in var.policies : p.name => p }

    name   = each.value.name
    policy = each.value.policy
}

resource "aws_iam_role_policy_attachment" "this" {
    for_each = aws_iam_policy.this
    
    role = aws_iam_role.execution_role.arn
    policy_arn = each.value.arn
}

resource "aws_iam_role" "eventbridge_role" {
    name = "${var.role_name}-eventbridge"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service = "events.amazonaws.com"
                }
                Action = "sts:AssumeRole"
            }
        ]
    })
}

resource "aws_iam_role_policy" "eventbridge_policy" {
    name = "${var.role_name}-eventbridge-policy"
    role = aws_iam_role.eventbridge_role.id

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "ecs:RunTask"
                ]
                Resource = var.cluster_arn
            },
            {
                Effect = "Allow"
                Action = [
                    "iam:PassRole"
                ]
                Resource = aws_iam_role.execution_role.arn
            }
        ]
    })
}