output "vpc_id" {
  value = module.vpc.vpc_id
}

output "ec2_instance_id" {
  value = aws_instance.app.id
}

output "rds_endpoint" {
  value = module.rds.endpoint
}

output "rds_secret_arn" {
  value = module.rds.master_user_secret_arn
}

output "s3_bucket_id" {
  value = module.s3.bucket_id
}
