provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project
      Environment = var.environment
      ManagedBy   = "Terraform"
      Scenario    = "level-2-growth"
    }
  }
}

locals {
  name      = "${var.project}-${var.environment}-l2"
  user_data = <<-EOT
    #!/bin/bash
    dnf install -y nginx
    systemctl enable --now nginx
    echo "ok" > /usr/share/nginx/html/index.html
  EOT
}

module "vpc" {
  source = "../../modules/vpc"

  name                 = local.name
  vpc_cidr             = "10.1.0.0/16"
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnet_cidrs = ["10.1.10.0/24", "10.1.11.0/24"]
  enable_nat_gateway   = true
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

resource "aws_security_group" "alb" {
  name        = "${local.name}-alb"
  description = "ALB HTTP ingress"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${local.name}-alb" }
}

resource "aws_security_group" "app" {
  name        = "${local.name}-app"
  description = "ASG instances — HTTP from ALB only"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

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

module "alb" {
  source = "../../modules/alb"

  name               = substr(local.name, 0, 32)
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.public_subnet_ids
  security_group_ids = [aws_security_group.alb.id]
  target_groups = {
    app = { port = 80, protocol = "HTTP" }
  }
  listener_weights = { app = 100 }
}

module "asg" {
  source = "../../modules/asg"

  name                  = "${local.name}-asg"
  subnet_ids            = module.vpc.private_subnet_ids
  ami_id                = var.ami_id
  instance_type         = var.instance_type
  instance_profile_name = module.iam.ec2_instance_profile_name
  security_group_ids    = [aws_security_group.app.id]
  target_group_arns     = [module.alb.target_group_arns["app"]]
  min_size              = 1
  max_size              = 3
  desired_capacity      = 2
  target_cpu_percent    = 50
  user_data             = local.user_data
}

module "rds" {
  source = "../../modules/rds"

  identifier              = "${local.name}-mysql"
  subnet_ids              = module.vpc.private_subnet_ids
  security_group_ids      = [aws_security_group.db.id]
  instance_class          = var.db_instance_class
  multi_az                = true
  create_read_replica     = var.create_read_replica
  backup_retention_period = var.backup_retention_period
  kms_key_arn             = aws_kms_key.this.arn
}

module "s3" {
  source = "../../modules/s3"

  name        = var.bucket_name
  kms_key_arn = aws_kms_key.this.arn
}

resource "aws_cloudwatch_metric_alarm" "asg_cpu" {
  alarm_name          = "${local.name}-asg-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "ASG average CPU high"

  dimensions = {
    AutoScalingGroupName = module.asg.asg_name
  }
}
