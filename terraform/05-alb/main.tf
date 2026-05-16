provider "aws" {
  region = var.aws_region
}

# Security Group compartido para EC2 y ALB
resource "aws_security_group" "sg_web" {
  name   = "gs-web"
  vpc_id = module.vpc.vpc_id

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

  tags = {
    Name = "SG Web"
  }
}

module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = "10.0.0.0/16"
  vpc_name             = "MiVPC-ALB"
  subnet_publica_cidr  = "10.0.1.0/24"
  subnet_publica2_cidr = "10.0.2.0/24"
  subnet_privada_cidr  = "10.0.3.0/24"
  az1                  = "us-east-1a"
  az2                  = "us-east-1b"
}

module "ec2_linux1" {
  source        = "./modules/ec2"
  instance_type = "t3.micro"
  subnet_id     = module.vpc.subnet_publica_id
  sg_id         = aws_security_group.sg_web.id
  name          = "Linux-1"
}

module "ec2_linux2" {
  source        = "./modules/ec2"
  instance_type = "t3.micro"
  subnet_id     = module.vpc.subnet_publica2_id
  sg_id         = aws_security_group.sg_web.id
  name          = "Linux-2"
}

module "alb" {
  source     = "./modules/alb"
  vpc_id     = module.vpc.vpc_id
  sg_id      = aws_security_group.sg_web.id
  subnet1_id = module.vpc.subnet_publica_id
  subnet2_id = module.vpc.subnet_publica2_id
  ec2_1_id   = module.ec2_linux1.instance_id
  ec2_2_id   = module.ec2_linux2.instance_id
}

output "alb_dns" {
  value = module.alb.alb_dns
}
