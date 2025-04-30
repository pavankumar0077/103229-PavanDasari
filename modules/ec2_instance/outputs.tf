output "id" {
  description = "The ID of the instance"
  value       = aws_instance.this.id
}

output "arn" {
  description = "The ARN of the instance"
  value       = aws_instance.this.arn
}

output "instance_state" {
  description = "The state of the instance"
  value       = aws_instance.this.instance_state
}

output "private_ip" {
  description = "The private IP address assigned to the instance"
  value       = aws_instance.this.private_ip
}

output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable"
  value       = aws_instance.this.public_ip
}

output "elastic_ip" {
  description = "The Elastic IP address assigned to the instance, if applicable"
  value       = var.create_elastic_ip ? aws_eip.this[0].public_ip : null
}

output "elastic_ip_id" {
  description = "The allocation ID of the Elastic IP address, if applicable"
  value       = var.create_elastic_ip ? aws_eip.this[0].id : null
}

output "primary_network_interface_id" {
  description = "The ID of the instance's primary network interface"
  value       = aws_instance.this.primary_network_interface_id
}

output "security_groups" {
  description = "The security groups associated with the instance"
  value       = aws_instance.this.security_groups
}

output "subnet_id" {
  description = "The subnet ID the instance was launched in"
  value       = aws_instance.this.subnet_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_instance.this.tags_all
}