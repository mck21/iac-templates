variable "name" {
  type        = string
  description = "Bucket name (must be globally unique)"
}

variable "kms_key_arn" {
  type        = string
  description = "KMS key ARN for SSE-KMS"
}

variable "enable_versioning" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
