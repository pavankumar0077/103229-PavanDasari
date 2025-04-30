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
  default     = "large"  # Larger profile for production environment
}

variable "instance_type" {
  description = "The type of instance to start (overrides workload_profile if specified)"
  type        = string
  default     = "t3.medium"  # Larger instance for production
}

variable "override_instance_types" {
  description = "List of instance types for mixed instances policy (right-sizing)"
  type        = list(string)
  default     = ["t3.medium", "t3a.medium", "t3.large", "t3a.large"]
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

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = false  # More secure for production - use load balancer instead
}

variable "create_elastic_ip" {
  description = "Whether to create an Elastic IP for the instance"
  type        = bool
  default     = false  # Use load balancer for production instead of direct access
}

# Security variables
variable "ssh_cidr_blocks" {
  description = "CIDR blocks to allow SSH access from"
  type        = list(string)
  default     = []  # More restrictive for production - specify exact IPs/ranges
}

variable "enable_http_access" {
  description = "Whether to allow HTTP access to the instance"
  type        = bool
  default     = false  # HTTP should be handled by load balancer in production
}

variable "http_cidr_blocks" {
  description = "CIDR blocks to allow HTTP access from"
  type        = list(string)
  default     = []
}

variable "enable_https_access" {
  description = "Whether to allow HTTPS access to the instance"
  type        = bool
  default     = false  # HTTPS should be handled by load balancer in production
}

variable "https_cidr_blocks" {
  description = "CIDR blocks to allow HTTPS access from"
  type        = list(string)
  default     = []
}

# Autoscaling variables
variable "enable_autoscaling" {
  description = "Whether to enable Auto Scaling Group instead of a single EC2 instance"
  type        = bool
  default     = true  # Use autoscaling by default in production
}

variable "min_size" {
  description = "Minimum size of the Auto Scaling Group"
  type        = number
  default     = 2  # Higher minimum for production
}

variable "max_size" {
  description = "Maximum size of the Auto Scaling Group"
  type        = number
  default     = 10
}

variable "desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "enable_scaling_policies" {
  description = "Whether to enable scaling policies for the Auto Scaling Group"
  type        = bool
  default     = true
}

variable "high_cpu_threshold" {
  description = "The value against which the specified statistic is compared for the scale up alarm"
  type        = number
  default     = 70  # More aggressive scaling for production
}

variable "low_cpu_threshold" {
  description = "The value against which the specified statistic is compared for the scale down alarm"
  type        = number
  default     = 30
}

variable "health_check_type" {
  description = "Controls how health checking is done (EC2 or ELB)"
  type        = string
  default     = "ELB"  # Use load balancer health checks in production
}

variable "target_group_arns" {
  description = "A list of Target Group ARNs to associate with the Auto Scaling Group"
  type        = list(string)
  default     = []
}

# Cost optimization variables
variable "use_spot_instances" {
  description = "Whether to use Spot Instances for cost optimization"
  type        = bool
  default     = true  # Use spot instances for cost savings
}

variable "spot_price" {
  description = "Maximum spot price for instances"
  type        = string
  default     = null  # Use on-demand price as maximum
}

variable "on_demand_base_capacity" {
  description = "Minimum amount of the Auto Scaling Group capacity that must be fulfilled by On-Demand Instances"
  type        = number
  default     = 1  # Keep at least one on-demand instance for stability
}

variable "on_demand_percentage_above_base_capacity" {
  description = "Percentage of On-Demand Instances above the base capacity"
  type        = number
  default     = 50  # Balance between cost and stability
}

# Cost tracking variables
variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "Operations Team"
}

variable "cost_center" {
  description = "Cost center for billing"
  type        = string
  default     = "CC-PROD-456"
}

variable "business_unit" {
  description = "Business unit for cost allocation"
  type        = string
  default     = "Operations"
}

# Additional tags
variable "additional_tags" {
  description = "Additional tags to add to resources"
  type        = map(string)
  default     = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}