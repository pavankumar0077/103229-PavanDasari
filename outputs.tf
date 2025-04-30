output "instance_id" {
  description = "The ID of the instance (if single instance deployment)"
  value       = var.enable_autoscaling ? null : try(module.ec2_instance[0].id, null)
}

output "instance_arn" {
  description = "The ARN of the instance (if single instance deployment)"
  value       = var.enable_autoscaling ? null : try(module.ec2_instance[0].arn, null)
}

output "instance_state" {
  description = "The state of the instance (if single instance deployment)"
  value       = var.enable_autoscaling ? null : try(module.ec2_instance[0].instance_state, null)
}

output "private_ip" {
  description = "The private IP address assigned to the instance (if single instance deployment)"
  value       = var.enable_autoscaling ? null : try(module.ec2_instance[0].private_ip, null)
}

output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable (if single instance deployment)"
  value       = var.enable_autoscaling ? null : try(module.ec2_instance[0].public_ip, null)
}

output "elastic_ip" {
  description = "The Elastic IP address assigned to the instance, if applicable (if single instance deployment)"
  value       = var.enable_autoscaling ? null : try(module.ec2_instance[0].elastic_ip, null)
}

output "security_group_id" {
  description = "The ID of the security group created for the instance, if applicable"
  value       = var.create_security_group ? aws_security_group.instance[0].id : null
}

output "security_group_name" {
  description = "The name of the security group created for the instance, if applicable"
  value       = var.create_security_group ? aws_security_group.instance[0].name : null
}

output "security_group_arn" {
  description = "The ARN of the security group created for the instance, if applicable"
  value       = var.create_security_group ? aws_security_group.instance[0].arn : null
}

# Autoscaling outputs
output "autoscaling_group_id" {
  description = "The ID of the Auto Scaling Group (if autoscaling deployment)"
  value       = var.enable_autoscaling ? try(module.autoscaling[0].autoscaling_group_id, null) : null
}

output "autoscaling_group_name" {
  description = "The name of the Auto Scaling Group (if autoscaling deployment)"
  value       = var.enable_autoscaling ? try(module.autoscaling[0].autoscaling_group_name, null) : null
}

output "autoscaling_group_arn" {
  description = "The ARN of the Auto Scaling Group (if autoscaling deployment)"
  value       = var.enable_autoscaling ? try(module.autoscaling[0].autoscaling_group_arn, null) : null
}

output "launch_template_id" {
  description = "The ID of the launch template (if autoscaling deployment)"
  value       = var.enable_autoscaling ? try(module.autoscaling[0].launch_template_id, null) : null
}

output "launch_template_arn" {
  description = "The ARN of the launch template (if autoscaling deployment)"
  value       = var.enable_autoscaling ? try(module.autoscaling[0].launch_template_arn, null) : null
}

output "scale_up_policy_arn" {
  description = "The ARN of the scale up policy (if autoscaling deployment with scaling policies)"
  value       = var.enable_autoscaling && var.enable_scaling_policies ? try(module.autoscaling[0].scale_up_policy_arn, null) : null
}

output "scale_down_policy_arn" {
  description = "The ARN of the scale down policy (if autoscaling deployment with scaling policies)"
  value       = var.enable_autoscaling && var.enable_scaling_policies ? try(module.autoscaling[0].scale_down_policy_arn, null) : null
}

output "high_cpu_alarm_arn" {
  description = "The ARN of the high CPU alarm (if autoscaling deployment with scaling policies)"
  value       = var.enable_autoscaling && var.enable_scaling_policies ? try(module.autoscaling[0].high_cpu_alarm_arn, null) : null
}

output "low_cpu_alarm_arn" {
  description = "The ARN of the low CPU alarm (if autoscaling deployment with scaling policies)"
  value       = var.enable_autoscaling && var.enable_scaling_policies ? try(module.autoscaling[0].low_cpu_alarm_arn, null) : null
}

output "instance_type" {
  description = "The instance type used (after right-sizing)"
  value       = local.selected_instance_type
}

output "cost_allocation_tags" {
  description = "The cost allocation tags applied to resources"
  value       = local.filtered_cost_allocation_tags
}