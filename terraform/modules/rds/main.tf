resource "aws_db_subnet_group" "this" {
  name       = "${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids
  tags       = merge(var.tags, { Name = "${var.identifier}-subnet-group" })
}

resource "aws_db_instance" "this" {
  identifier     = var.identifier
  engine         = "mysql"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.allocated_storage * 2
  db_name               = var.db_name
  username              = var.master_username

  manage_master_user_password = true
  storage_encrypted           = true
  kms_key_id                  = var.kms_key_arn

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.security_group_ids

  multi_az                = var.multi_az
  publicly_accessible     = false
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = merge(var.tags, { Name = var.identifier })
}

resource "aws_db_instance" "replica" {
  count = var.create_read_replica ? 1 : 0

  identifier          = "${var.identifier}-replica"
  replicate_source_db = aws_db_instance.this.identifier
  instance_class      = var.instance_class

  storage_encrypted = true
  kms_key_id        = var.kms_key_arn

  vpc_security_group_ids = var.security_group_ids
  publicly_accessible    = false
  skip_final_snapshot    = true

  tags = merge(var.tags, { Name = "${var.identifier}-replica" })
}
