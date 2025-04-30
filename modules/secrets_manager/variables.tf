variable "create_secret" {
  description = "Whether to create a new secret or use an existing one"
  type        = bool
  default     = false
}

variable "secret_name" {
  description = "Name of the secret in AWS Secrets Manager"
  type        = string
}

variable "secret_description" {
  description = "Description of the secret"
  type        = string
  default     = "Managed by Terraform"
}

variable "secret_string" {
  description = "Text to store in the secret. Cannot be used with secret_key_value_map"
  type        = string
  default     = null
  sensitive   = true
}

variable "secret_key_value_map" {
  description = "Map of key/value pairs to store as JSON in the secret. Cannot be used with secret_string"
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "kms_key_id" {
  description = "ARN or ID of the AWS KMS key to be used to encrypt the secret"
  type        = string
  default     = null
}

variable "recovery_window_in_days" {
  description = "Number of days that AWS Secrets Manager waits before it can delete the secret"
  type        = number
  default     = 30
}

variable "parse_json_value" {
  description = "Whether to parse the secret value as JSON"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to the secret"
  type        = map(string)
  default     = {}
}