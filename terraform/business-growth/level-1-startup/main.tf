provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project
      Environment = var.environment
      ManagedBy   = "Terraform"
      Scenario    = "level-1-startup"
    }
  }
}

locals {
  name = "${var.project}-${var.environment}-l1"
}

module "vpc" {
  source = "../../modules/vpc"

  name                 = local.name
  vpc_cidr             = "10.0.0.0/16"
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = ["10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
  enable_nat_gateway   = false
}

module "iam" {
  source = "../../modules/iam"

  name           = local.name
  enable_ec2_ssm = true
}

resource "aws_kms_key" "this" {
  description             = "${local.name} encryption key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "this" {
  name          = "alias/${local.name}"
  target_key_id = aws_kms_key.this.key_id
}

resource "aws_security_group" "app" {
  name        = "${local.name}-app"
  description = "App EC2 — no inbound SSH; SSM only"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${local.name}-app" }
}

resource "aws_security_group" "db" {
  name        = "${local.name}-db"
  description = "MySQL from app SG only"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${local.name}-db" }
}

resource "aws_instance" "app" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.app.id]
  iam_instance_profile   = module.iam.ec2_instance_profile_name

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted = true
  }

  tags = { Name = "${local.name}-app" }
}

module "rds" {
  source = "../../modules/rds"

  identifier              = "${local.name}-mysql"
  subnet_ids              = module.vpc.private_subnet_ids
  security_group_ids      = [aws_security_group.db.id]
  instance_class          = var.db_instance_class
  multi_az                = false
  create_read_replica     = false
  backup_retention_period = 1
  kms_key_arn             = aws_kms_key.this.arn
}

module "s3" {
  source = "../../modules/s3"

  name        = var.bucket_name
  kms_key_arn = aws_kms_key.this.arn
}
