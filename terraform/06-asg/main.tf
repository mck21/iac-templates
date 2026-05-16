provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = "10.0.0.0/16"
  vpc_name            = "MiVPC-ASG"
  subnet_publica_cidr = "10.0.1.0/24"
  subnet_privada_cidr = "10.0.2.0/24"
}

module "asg" {
  source        = "./modules/asg"
  instance_type = "t3.micro"
  subnet_id     = module.vpc.subnet_publica_id
}

output "asg_name" {
  value = module.asg.asg_name
}
