variable "name" {
  type        = string
  description = "Name prefix for VPC resources"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  type        = list(string)
  description = "AZs for subnets (must match subnet CIDR list lengths)"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public subnet CIDRs (one per AZ entry used)"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnet CIDRs (one per AZ entry used)"
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Create a single NAT Gateway in the first public subnet"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Extra tags"
  default     = {}
}
