output "vpc_id" {
  value = module.vpc.vpc_id
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "asg_name" {
  value = module.asg.asg_name
}

output "rds_endpoint" {
  value = module.rds.endpoint
}

output "rds_reader_endpoint" {
  value = module.rds.reader_endpoint
}

output "s3_bucket_id" {
  value = module.s3.bucket_id
}
