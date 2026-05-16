provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = "10.0.0.0/16"
  vpc_name             = "MiVPC-RDS"
  subnet_publica_cidr  = "10.0.1.0/24"
  subnet_privada_cidr  = "10.0.2.0/24"
  subnet_privada2_cidr = "10.0.3.0/24"
  az1                  = "us-east-1a"
  az2                  = "us-east-1b"
}

# SG para el EC2 público (permite SSH)
resource "aws_security_group" "sg_ec2" {
  name   = "gs-ec2"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "SG EC2" }
}

# SG para RDS: solo acepta MySQL (3306) desde el SG del EC2
resource "aws_security_group" "sg_rds" {
  name   = "gs-rds"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_ec2.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "SG RDS" }
}

module "ec2" {
  source        = "./modules/ec2"
  instance_type = "t3.micro"
  subnet_id     = module.vpc.subnet_publica_id
  sg_id         = aws_security_group.sg_ec2.id
}

module "rds" {
  source             = "./modules/rds"
  subnet_privada_id  = module.vpc.subnet_privada_id
  subnet_privada2_id = module.vpc.subnet_privada2_id
  sg_rds_id          = aws_security_group.sg_rds.id
  db_user            = var.db_user
  db_password        = var.db_password
}

output "ec2_id" {
  value = module.ec2.instance_id
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}
