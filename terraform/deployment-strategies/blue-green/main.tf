provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project
      Environment = var.environment
      ManagedBy   = "Terraform"
      Scenario    = "blue-green"
    }
  }
}

locals {
  name   = "${var.project}-${var.environment}-bg"
  colors = toset(["blue", "green"])
  listener_weights = {
    blue  = var.active_color == "blue" ? 100 : 0
    green = var.active_color == "green" ? 100 : 0
  }
  user_data = {
    blue  = <<-EOT
      #!/bin/bash
      dnf install -y nginx
      systemctl enable --now nginx
      echo "blue" > /usr/share/nginx/html/index.html
    EOT
    green = <<-EOT
      #!/bin/bash
      dnf install -y nginx
      systemctl enable --now nginx
      echo "green" > /usr/share/nginx/html/index.html
    EOT
  }
}

module "vpc" {
  source = "../../modules/vpc"

  name                 = local.name
  vpc_cidr             = "10.2.0.0/16"
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = ["10.2.1.0/24", "10.2.2.0/24"]
  private_subnet_cidrs = ["10.2.10.0/24", "10.2.11.0/24"]
  enable_nat_gateway   = true
}

module "iam" {
  source = "../../modules/iam"

  name           = local.name
  enable_ec2_ssm = true
}

resource "aws_security_group" "alb" {
  name        = "${local.name}-alb"
  description = "ALB HTTP"
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
  description = "ASG from ALB only"
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

module "alb" {
  source = "../../modules/alb"

  name               = substr(local.name, 0, 32)
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.public_subnet_ids
  security_group_ids = [aws_security_group.alb.id]
  target_groups = {
    blue  = { port = 80, protocol = "HTTP" }
    green = { port = 80, protocol = "HTTP" }
  }
  listener_weights = local.listener_weights
}

module "asg" {
  source   = "../../modules/asg"
  for_each = local.colors

  name                  = "${local.name}-${each.key}"
  subnet_ids            = module.vpc.private_subnet_ids
  ami_id                = var.ami_id
  instance_type         = var.instance_type
  instance_profile_name = module.iam.ec2_instance_profile_name
  security_group_ids    = [aws_security_group.app.id]
  target_group_arns     = [module.alb.target_group_arns[each.key]]
  min_size              = 1
  max_size              = 2
  desired_capacity      = 1
  target_cpu_percent    = null
  user_data             = local.user_data[each.key]
  tags                  = { Color = each.key }
}
