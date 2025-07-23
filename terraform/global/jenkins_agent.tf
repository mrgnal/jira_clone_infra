resource "aws_iam_role" "jenkins_agent" {
  name = "jenkins-agent-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }
    ]
  })
}

resource "aws_iam_policy" "jenkins_agent" {
  name        = "jenkins-agent-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ecr:GetAuthorizationToken",
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
        Resource = [
          module.app_ecr.repository_arn,
          module.migrate_ecr.repository_arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_agent" {
  role = aws_iam_role.jenkins_agent.name
  policy_arn = aws_iam_policy.jenkins_agent.arn
}

resource "aws_iam_instance_profile" "jenkins_agent" {
  name = "jenkins-agent-profile"
  role = aws_iam_role.jenkins_agent.name
}

resource "aws_security_group" "jenkins_agent" {
  name = "jenkins-agent-sg"
  vpc_id = module.network.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.jenkins_sg.id]
  }

  ingress {
    from_port = 50000
    to_port = 50000
    protocol = "tcp"
    security_groups = [aws_security_group.jenkins_sg.id]
  }

  egress {
    to_port = 0
    from_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}