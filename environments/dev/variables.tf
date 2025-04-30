variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "example-project"
}

variable "ami_id" {
  description = "ID of AMI to use for the instance"
  type        = string
}

# Right-sizing variables
variable "workload_profile" {
  description = "Predefined workload profile for right-sizing (small, medium, large, xlarge, compute-optimized, memory-optimized)"
  type        = string
  default     = "small"  # Small profile for dev environment
}

variable "instance_type" {
  description = "The type of instance to start (overrides workload_profile if specified)"
  type        = string
  default     = "t3.micro"  # Smaller instance for dev environment
}

variable "override_instance_types" {
  description = "List of instance types for mixed instances policy (right-sizing)"
  type        = list(string)
  default     = []
}

# Network variables
variable "subnet_id" {
  description = "The VPC Subnet ID to launch in (for single instance)"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "A list of subnet IDs to launch resources in (for Auto Scaling Group)"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "The VPC ID where resources will be created"
  type        = string
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance"
  type        = string
}

# Security variables
variable "ssh_cidr_blocks" {
  description = "CIDR blocks to allow SSH access from"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # More permissive for dev, but should be restricted in production
}

variable "http_cidr_blocks" {
  description = "CIDR blocks to allow HTTP access from"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "https_cidr_blocks" {
  description = "CIDR blocks to allow HTTPS access from"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Autoscaling variables
variable "enable_autoscaling" {
  description = "Whether to enable Auto Scaling Group instead of a single EC2 instance"
  type        = bool
  default     = false
}

variable "min_size" {
  description = "Minimum size of the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum size of the Auto Scaling Group"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "enable_scaling_policies" {
  description = "Whether to enable scaling policies for the Auto Scaling Group"
  type        = bool
  default     = false
}

variable "high_cpu_threshold" {
  description = "The value against which the specified statistic is compared for the scale up alarm"
  type        = number
  default     = 80
}

variable "low_cpu_threshold" {
  description = "The value against which the specified statistic is compared for the scale down alarm"
  type        = number
  default     = 20
}

# Cost optimization variables
variable "use_spot_instances" {
  description = "Whether to use Spot Instances for cost optimization"
  type        = bool
  default     = false
}

variable "spot_price" {
  description = "Maximum spot price for instances"
  type        = string
  default     = null
}

# Cost tracking variables
variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "DevOps Team"
}

variable "cost_center" {
  description = "Cost center for billing"
  type        = string
  default     = "CC-DEV-123"
}

variable "business_unit" {
  description = "Business unit for cost allocation"
  type        = string
  default     = "Engineering"
}

# Additional tags
variable "additional_tags" {
  description = "Additional tags to add to resources"
  type        = map(string)
  default     = {
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}