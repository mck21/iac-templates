variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "target_groups" {
  type = map(object({
    port     = optional(number, 80)
    protocol = optional(string, "HTTP")
  }))
  description = "Map of target group keys (e.g. app, blue, green) to settings"
}

variable "listener_weights" {
  type        = map(number)
  description = "Map of target group key -> weight (e.g. { blue = 100, green = 0 }). Keys must match target_groups."
  default     = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
