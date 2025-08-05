resource "aws_db_subnet_group" "this" {
    name = "rds-subnet-group"
    subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "this" {
    identifier =  var.identifier
    allocated_storage = var.allocated_storage
    engine = var.engine
    engine_version = var.engine_version
    instance_class = var.instance_class
    db_subnet_group_name = aws_db_subnet_group.this.name
    publicly_accessible = var.publicly_accessible
    skip_final_snapshot = var.skip_final_snapshot
    multi_az = var.multi_az
    storage_encrypted = var.storage_encrypted
    vpc_security_group_ids = [aws_security_group.rds.id]

    db_name = var.db_name
    username = var.db_username
    password = var.db_password

    enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
    monitoring_interval = 60
    monitoring_role_arn = aws_iam_role.rds_monitoring.arn
}

resource "aws_iam_role" "rds_monitoring" {
  name = "rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "monitoring.rds.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
