/**
 * # EC2 Instance Module
 *
 * This module creates an EC2 instance with configurable parameters
 * following AWS best practices.
 */

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name
  
  iam_instance_profile   = var.iam_instance_profile
  
  user_data              = var.user_data
  user_data_base64       = var.user_data_base64
  
  associate_public_ip_address = var.associate_public_ip_address
  
  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    delete_on_termination = var.root_volume_delete_on_termination
    encrypted             = var.root_volume_encrypted
    kms_key_id            = var.root_volume_kms_key_id
  }
  
  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
  
  volume_tags = merge(
    {
      Name = var.name
    },
    var.volume_tags
  )
  
  metadata_options {
    http_endpoint               = var.metadata_http_endpoint
    http_tokens                 = var.metadata_http_tokens
    http_put_response_hop_limit = var.metadata_http_put_response_hop_limit
  }
  
  monitoring = var.enable_detailed_monitoring
  
  lifecycle {
    create_before_destroy = true
  }
}

# Conditionally create an Elastic IP if public IP is requested
resource "aws_eip" "this" {
  count    = var.create_elastic_ip ? 1 : 0
  instance = aws_instance.this.id
  domain   = "vpc"
  
  tags = merge(
    {
      Name = "${var.name}-eip"
    },
    var.tags
  )
}