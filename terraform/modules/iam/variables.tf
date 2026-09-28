variable "name" {
  type        = string
  description = "Name prefix for IAM resources"
}

variable "enable_ec2_ssm" {
  type        = bool
  description = "Create EC2 instance profile with AmazonSSMManagedInstanceCore"
  default     = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
