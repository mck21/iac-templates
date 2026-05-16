provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = "10.0.0.0/16"
  vpc_name            = "MiVPC-Windows"
  subnet_publica_cidr = "10.0.1.0/24"
  subnet_privada_cidr = "10.0.2.0/24"
}

module "ec2_windows" {
  source        = "./modules/ec2"
  instance_type = "t3.micro"
  subnet_id     = module.vpc.subnet_publica_id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "ec2_windows_id" {
  value = module.ec2_windows.windows_instance_id
}
