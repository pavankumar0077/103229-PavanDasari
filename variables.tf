variable "instance_name" {
  description = "Name to be used on EC2 instance created"
  type        = string
}

variable "ami_id" {
  description = "ID of AMI to use for the instance"
  type        = string
}

# Right-sizing variables
variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}

variable "workload_profile" {
  description = "Predefined workload profile for right-sizing (small, medium, large, xlarge, compute-optimized, memory-optimized)"
  type        = string
  default     = "small"
}

variable "override_instance_types" {
  description = "List of instance types for mixed instances policy (right-sizing)"
  type        = list(string)
  default     = []
}

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

variable "on_demand_base_capacity" {
  description = "Minimum amount of the Auto Scaling Group capacity that must be fulfilled by On-Demand Instances"
  type        = number
  default     = 0
}

variable "on_demand_percentage_above_base_capacity" {
  description = "Percentage of On-Demand Instances above the base capacity"
  type        = number
  default     = 100
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

variable "health_check_type" {
  description = "Controls how health checking is done (EC2 or ELB)"
  type        = string
  default     = "EC2"
}

variable "target_group_arns" {
  description = "A list of Target Group ARNs to associate with the Auto Scaling Group"
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

# Volume variables
variable "root_volume_size" {
  description = "The size of the volume in gigabytes"
  type        = number
  default     = 20
}

variable "root_volume_type" {
  description = "The type of volume. Can be 'standard', 'gp2', 'gp3', 'io1', 'io2', 'sc1', or 'st1'"
  type        = string
  default     = "gp3"
}

variable "root_volume_encrypted" {
  description = "Whether to enable volume encryption"
  type        = bool
  default     = true
}

variable "user_data" {
  description = "The user data to provide when launching the instance"
  type        = string
  default     = null
}

# Tagging variables
variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "additional_tags" {
  description = "Additional tags to add to resources"
  type        = map(string)
  default     = {}
}

# Cost allocation tagging
variable "cost_center" {
  description = "Cost center for cost allocation tagging"
  type        = string
  default     = ""
}

variable "project" {
  description = "Project name for cost allocation tagging"
  type        = string
  default     = ""
}

variable "owner" {
  description = "Owner for cost allocation tagging"
  type        = string
  default     = ""
}

variable "business_unit" {
  description = "Business unit for cost allocation tagging"
  type        = string
  default     = ""
}

# Security group variables
variable "create_security_group" {
  description = "Whether to create a security group for the EC2 instance"
  type        = bool
  default     = false
}

variable "ssh_cidr_blocks" {
  description = "CIDR blocks to allow SSH access from"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enable_http_access" {
  description = "Whether to allow HTTP access to the instance"
  type        = bool
  default     = false
}

variable "http_cidr_blocks" {
  description = "CIDR blocks to allow HTTP access from"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enable_https_access" {
  description = "Whether to allow HTTPS access to the instance"
  type        = bool
  default     = false
}

variable "https_cidr_blocks" {
  description = "CIDR blocks to allow HTTPS access from"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Monitoring variables
variable "enable_detailed_monitoring" {
  description = "Whether to enable detailed monitoring"
  type        = bool
  default     = false
}