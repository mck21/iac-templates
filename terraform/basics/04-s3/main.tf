provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = "10.0.0.0/16"
  vpc_name            = "MiVPC-S3"
  subnet_publica_cidr = "10.0.1.0/24"
  subnet_privada_cidr = "10.0.2.0/24"
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "bucket_id" {
  value = module.s3.bucket_id
}
