variable "aws_region" {
  default = "us-east-1"
}

variable "db_user" {
  default = "admin"
}

variable "db_password" {
  sensitive = true
}
