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
    vpc_security_group_ids = var.rds_sg

    db_name = var.db_name
    username = var.db_username
    password = var.db_password
}