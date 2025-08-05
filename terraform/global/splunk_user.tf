resource "aws_iam_user" "splunk_user" {
  name = "splunk-user"
}

resource "aws_iam_access_key" "splunk_user_key" {
  user = aws_iam_user.splunk_user.name
}

resource "aws_iam_policy" "cloudwatch_logs_access" {
  name        = "CloudWatchLogsFullAccess"
  description = "Allow full access to CloudWatch Logs"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = [
        "logs:*"
      ],
      Resource = "*"
    }]
  })
}

resource "aws_iam_user_policy_attachment" "attach_policy" {
  user       = aws_iam_user.splunk_user.name
  policy_arn = aws_iam_policy.cloudwatch_logs_access.arn
}