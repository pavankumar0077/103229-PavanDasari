variable "name" {
  description = "Name to be used for the Auto Scaling Group and related resources"
  type        = string
}

variable "ami_id" {
  description = "ID of AMI to use for the instances"
  type        = string
}

# Right-sizing variables
variable "instance_type" {
  description = "The primary instance type to use for the Auto Scaling Group"
  type        = string
  default     = "t3.micro"
}

variable "override_instance_types" {
  description = "List of instance types for mixed instances policy (right-sizing)"
  type        = list(string)
  default     = []
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

variable "spot_allocation_strategy" {
  description = "How to allocate capacity across Spot Instance pools"
  type        = string
  default     = "capacity-optimized"
}

variable "spot_instance_pools" {
  description = "Number of Spot Instance pools to use (only used with lowest-price strategy)"
  type        = number
  default     = 2
}

variable "use_spot_instances" {
  description = "Whether to use Spot Instances for the primary launch template"
  type        = bool
  default     = false
}

variable "spot_price" {
  description = "Maximum spot price for instances"
  type        = string
  default     = null
}

# Auto Scaling Group variables
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

variable "subnet_ids" {
  description = "A list of subnet IDs to launch resources in"
  type        = list(string)
}

variable "security_group_ids" {
  description = "A list of security group IDs to associate with the instances"
  type        = list(string)
  default     = []
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instances"
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile to launch the instances with"
  type        = string
  default     = null
}

variable "user_data" {
  description = "The user data to provide when launching the instances"
  type        = string
  default     = null
}

variable "user_data_base64" {
  description = "Can be used instead of user_data to pass base64-encoded binary data directly"
  type        = string
  default     = null
}

variable "health_check_type" {
  description = "Controls how health checking is done (EC2 or ELB)"
  type        = string
  default     = "EC2"
}

variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  type        = number
  default     = 300
}

variable "force_delete" {
  description = "Whether to force delete the Auto Scaling Group without waiting for all instances to terminate"
  type        = bool
  default     = false
}

variable "termination_policies" {
  description = "A list of policies to decide how the instances in the Auto Scaling Group should be terminated"
  type        = list(string)
  default     = ["Default"]
}

variable "suspended_processes" {
  description = "A list of processes to suspend for the Auto Scaling Group"
  type        = list(string)
  default     = []
}

variable "target_group_arns" {
  description = "A list of Target Group ARNs to associate with the Auto Scaling Group"
  type        = list(string)
  default     = []
}

variable "default_cooldown" {
  description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start"
  type        = number
  default     = 300
}

# Instance refresh
variable "enable_instance_refresh" {
  description = "Whether to enable instance refresh for the Auto Scaling Group"
  type        = bool
  default     = false
}

variable "instance_refresh_min_healthy_percentage" {
  description = "Minimum percentage of healthy instances during instance refresh"
  type        = number
  default     = 90
}

variable "instance_refresh_warmup" {
  description = "The number of seconds until a newly launched instance is considered to have completed initialization"
  type        = number
  default     = 300
}

# Volume configuration
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

# Tagging
variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default     = {}
}

variable "volume_tags" {
  description = "A mapping of tags to assign to the volumes"
  type        = map(string)
  default     = {}
}

# Cost allocation tagging
variable "cost_allocation_tags" {
  description = "A mapping of tags to assign to resources for cost allocation"
  type        = map(string)
  default     = {}
}

# Monitoring
variable "enable_detailed_monitoring" {
  description = "Whether to enable detailed monitoring"
  type        = bool
  default     = false
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

# Auto Scaling Policies
variable "enable_scaling_policies" {
  description = "Whether to enable scaling policies for the Auto Scaling Group"
  type        = bool
  default     = false
}

variable "scale_up_adjustment" {
  description = "The number of instances by which to scale up"
  type        = number
  default     = 1
}

variable "scale_up_cooldown" {
  description = "The amount of time, in seconds, after a scale up activity completes before another scale up activity can start"
  type        = number
  default     = 300
}

variable "scale_down_adjustment" {
  description = "The number of instances by which to scale down (negative number)"
  type        = number
  default     = -1
}

variable "scale_down_cooldown" {
  description = "The amount of time, in seconds, after a scale down activity completes before another scale down activity can start"
  type        = number
  default     = 300
}

# CloudWatch Alarms
variable "high_cpu_threshold" {
  description = "The value against which the specified statistic is compared for the scale up alarm"
  type        = number
  default     = 80
}

variable "high_cpu_evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold for the scale up alarm"
  type        = number
  default     = 2
}

variable "high_cpu_period" {
  description = "The period in seconds over which the specified statistic is applied for the scale up alarm"
  type        = number
  default     = 300
}

variable "low_cpu_threshold" {
  description = "The value against which the specified statistic is compared for the scale down alarm"
  type        = number
  default     = 20
}

variable "low_cpu_evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold for the scale down alarm"
  type        = number
  default     = 2
}

variable "low_cpu_period" {
  description = "The period in seconds over which the specified statistic is applied for the scale down alarm"
  type        = number
  default     = 300
}