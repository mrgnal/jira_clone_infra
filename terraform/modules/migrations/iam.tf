resource "aws_iam_role" "this" {
    name = var.role_name

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Principal = {
              Service = "lambda.amazonaws.com"
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
    
    role = aws_iam_role.this.name
    policy_arn = each.value.arn
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
