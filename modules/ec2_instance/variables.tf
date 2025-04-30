variable "name" {
  description = "Name to be used on EC2 instance created"
  type        = string
}

variable "ami_id" {
  description = "ID of AMI to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
}

variable "security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = []
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance"
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile to launch the instance with"
  type        = string
  default     = null
}

variable "user_data" {
  description = "The user data to provide when launching the instance"
  type        = string
  default     = null
}

variable "user_data_base64" {
  description = "Can be used instead of user_data to pass base64-encoded binary data directly"
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = false
}

variable "create_elastic_ip" {
  description = "Whether to create an Elastic IP for the instance"
  type        = bool
  default     = false
}

variable "root_volume_type" {
  description = "The type of volume. Can be 'standard', 'gp2', 'gp3', 'io1', 'io2', 'sc1', or 'st1'"
  type        = string
  default     = "gp3"
}

variable "root_volume_size" {
  description = "The size of the volume in gigabytes"
  type        = number
  default     = 20
}

variable "root_volume_delete_on_termination" {
  description = "Whether the volume should be destroyed on instance termination"
  type        = bool
  default     = true
}

variable "root_volume_encrypted" {
  description = "Whether to enable volume encryption"
  type        = bool
  default     = true
}

variable "root_volume_kms_key_id" {
  description = "Amazon Resource Name (ARN) of the KMS Key to use when encrypting the volume"
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "volume_tags" {
  description = "A mapping of tags to assign to the volumes"
  type        = map(string)
  default     = {}
}

variable "metadata_http_endpoint" {
  description = "Whether the metadata service is available. Can be 'enabled' or 'disabled'"
  type        = string
  default     = "enabled"
}

variable "metadata_http_tokens" {
  description = "Whether or not the metadata service requires session tokens, also referred to as Instance Metadata Service Version 2 (IMDSv2). Can be 'optional' or 'required'"
  type        = string
  default     = "required"  # IMDSv2 is more secure
}

variable "metadata_http_put_response_hop_limit" {
  description = "The desired HTTP PUT response hop limit for instance metadata requests"
  type        = number
  default     = 1
}

variable "enable_detailed_monitoring" {
  description = "Whether to enable detailed monitoring"
  type        = bool
  default     = false
}