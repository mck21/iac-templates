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
  description = "Amazon Linux 2023 AMI in aws_region"
  default     = "ami-0d64bb532e05042c5"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "bucket_name" {
  type    = string
  default = "iac-portfolio-l2-dev-change-me"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "create_read_replica" {
  type    = bool
  default = true
}

variable "backup_retention_period" {
  type    = number
  default = 7

  validation {
    condition     = !var.create_read_replica || var.backup_retention_period >= 1
    error_message = "backup_retention_period must be >= 1 when create_read_replica is true."
  }
}
