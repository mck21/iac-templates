variable "name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ami_id" {
  type = string
}

variable "instance_profile_name" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "target_group_arns" {
  type    = list(string)
  default = []
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 2
}

variable "desired_capacity" {
  type    = number
  default = 1
}

variable "target_cpu_percent" {
  type        = number
  description = "Target tracking CPU utilization. Set null to disable."
  default     = 50
  nullable    = true
}

variable "user_data" {
  type     = string
  default  = null
  nullable = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
