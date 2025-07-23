#EC2
resource "aws_instance" "jenkins" {
  ami = var.ami
  instance_type = var.instance_type 
  availability_zone = "${var.region}a"
  key_name = aws_key_pair.jenkins_key.key_name
  subnet_id = module.network.public_subnets_ids[0]
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  iam_instance_profile = aws_iam_instance_profile.jenkins_master.name

  root_block_device {
    volume_size = 20
  }

  user_data = file("./jenkins-files/jenkins_init.sh")

  tags = {
    Name = "jenkins"
  }
}

#IP
resource "aws_eip" "jenkins_ip" {
  instance = aws_instance.jenkins.id
}

#SSH key generation
resource "tls_private_key" "jenkins_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "jenkins_key" {
  key_name = "jenkins-key"
  public_key = tls_private_key.jenkins_key.public_key_openssh
}

resource "local_file" "private_key" {
  content = tls_private_key.jenkins_key.private_key_pem
  filename = "${path.module}/jenkins-files/jenkins-key.pem"
  file_permission = "0600"
}

#SG
resource "aws_security_group" "jenkins_sg" {
  vpc_id = module.network.vpc_id
  name = "jenkins_sg"

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
  }

    egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "jenkins_master" {
  name = "jenkins-master-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "jenkins_master_policy" {
  name        = "jenkins-master-policy"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ec2:DescribeSpotInstanceRequests",
                "ec2:CancelSpotInstanceRequests",
                "ec2:GetConsoleOutput",
                "ec2:RequestSpotInstances",
                "ec2:RunInstances",
                "ec2:StartInstances",
                "ec2:StopInstances",
                "ec2:TerminateInstances",
                "ec2:CreateTags",
                "ec2:DeleteTags",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceTypes",
                "ec2:DescribeKeyPairs",
                "ec2:DescribeRegions",
                "ec2:DescribeImages",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "iam:ListInstanceProfilesForRole",
                "iam:PassRole",
                "ec2:GetPasswordData"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
})
}

resource "aws_iam_role_policy_attachment" "jenkins_master" {
  policy_arn = aws_iam_policy.jenkins_master_policy.arn
  role = aws_iam_role.jenkins_master.name
}

resource "aws_iam_instance_profile" "jenkins_master" {
    name = "jenkins-master-profile"
    role = aws_iam_role.jenkins_master.name
}


#Auto backup
# resource "aws_iam_role" "backup_role" {
#   name = "aws_backup_role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Principal = {
#         Service = "backup.amazonaws.com"
#       }
#       Action = "sts:AssumeRole"
#     }]
#   })
# }

# resource "aws_iam_role_policy" "backup_policy" {
#   name = "aws_backup_policy"
#   role = aws_iam_role.backup_role.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "ec2:DescribeVolumes",
#           "ec2:CreateSnapshot",
#           "ec2:DeleteSnapshot",
#           "ec2:DescribeSnapshots",
#           "ec2:CreateTags",
#           "backup:CopyIntoBackupVault",
#           "backup:StartBackupJob"
#         ]
#         Resource = "*"
#       }
#     ]
#   })
# }

# resource "aws_backup_vault" "jenkins_vault" {
#   name = "jenkins-backup-vault"
# }

# resource "aws_backup_plan" "jenkins_backup_plan" {
#   name = "jenkins-backup-plan"

#   rule {
#     rule_name         = "daily-backup"
#     target_vault_name = aws_backup_vault.jenkins_vault.name
#     schedule          = "cron(0 3 * * ? *)" 
#     lifecycle {
#       delete_after = 5
#     }
#   }
# }

# resource "aws_backup_selection" "jenkins_backup_selection" {
#   name          = "jenkins-backup-selection"
#   iam_role_arn  = aws_iam_role.backup_role.arn
#   plan_id       = aws_backup_plan.jenkins_backup_plan.id

#   resources = [
#     aws_instance.jenkins.arn
#   ]
# }
