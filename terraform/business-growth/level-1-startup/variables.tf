variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "project" {
  type    = string
  default = "iac-portfolio"
}

variable "availability_zones" {
  type    = list(string)
  default = ["eu-west-1a", "eu-west-1b"]
}

variable "ami_id" {
  type        = string
  description = "Amazon Linux 2023 AMI in aws_region (no data source — offline validate)"
  default     = "ami-0d64bb532e05042c5"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "bucket_name" {
  type        = string
  description = "Globally unique S3 bucket name"
  default     = "iac-portfolio-l1-dev-change-me"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}
