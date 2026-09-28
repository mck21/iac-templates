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
  type    = string
  default = "ami-0d64bb532e05042c5"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "active_color" {
  type        = string
  description = "Which color receives 100% of ALB traffic"
  default     = "blue"

  validation {
    condition     = contains(["blue", "green"], var.active_color)
    error_message = "active_color must be \"blue\" or \"green\"."
  }
}
