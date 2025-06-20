resource "aws_iam_user" "jenkins_user" {
  name = "jenkins-ecr"
}

resource "aws_iam_policy" "ecr_access_policy" {
  name        = "ECRJenkinsAccess"
  description = "Allow Jenkins to push/pull images to ECR"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Resource = aws_ecr_repository.jira_repo.arn
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "jenkins_ecr_attach" {
  user       = aws_iam_user.jenkins_user.name
  policy_arn = aws_iam_policy.ecr_access_policy.arn
}


resource "aws_iam_access_key" "jenkins_key" {
  user = aws_iam_user.jenkins_user.name
}