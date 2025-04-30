/**
 * # AWS EC2 Instance Deployment
 *
 * This is the root module that creates either a single EC2 instance or an Auto Scaling Group
 * with right-sizing, autoscaling, and cost tracking capabilities.
 */

# Local variables for right-sizing and cost tracking
locals {
  # Right-sizing: Map workload profiles to instance types
  instance_type_map = {
    small             = var.instance_type != "t3.micro" ? var.instance_type : "t3.micro"
    medium            = var.instance_type != "t3.micro" ? var.instance_type : "t3.medium"
    large             = var.instance_type != "t3.micro" ? var.instance_type : "t3.large"
    xlarge            = var.instance_type != "t3.micro" ? var.instance_type : "t3.xlarge"
    compute-optimized = var.instance_type != "t3.micro" ? var.instance_type : "c5.large"
    memory-optimized  = var.instance_type != "t3.micro" ? var.instance_type : "r5.large"
  }

  # Select instance type based on workload profile or use the provided instance_type
  selected_instance_type = lookup(local.instance_type_map, var.workload_profile, var.instance_type)

  # Right-sizing: Define alternative instance types for each workload profile
  override_instance_types_map = {
    small             = length(var.override_instance_types) > 0 ? var.override_instance_types : ["t3.micro", "t3a.micro", "t2.micro"]
    medium            = length(var.override_instance_types) > 0 ? var.override_instance_types : ["t3.medium", "t3a.medium", "t2.medium"]
    large             = length(var.override_instance_types) > 0 ? var.override_instance_types : ["t3.large", "t3a.large", "t2.large"]
    xlarge            = length(var.override_instance_types) > 0 ? var.override_instance_types : ["t3.xlarge", "t3a.xlarge", "t2.xlarge"]
    compute-optimized = length(var.override_instance_types) > 0 ? var.override_instance_types : ["c5.large", "c5a.large", "c5n.large"]
    memory-optimized  = length(var.override_instance_types) > 0 ? var.override_instance_types : ["r5.large", "r5a.large", "r5n.large"]
  }

  # Select override instance types based on workload profile or use the provided override_instance_types
  selected_override_instance_types = lookup(local.override_instance_types_map, var.workload_profile, var.override_instance_types)

  # Cost allocation tags
  cost_allocation_tags = {
    CostCenter   = var.cost_center != "" ? var.cost_center : null
    Project      = var.project != "" ? var.project : null
    Owner        = var.owner != "" ? var.owner : null
    BusinessUnit = var.business_unit != "" ? var.business_unit : null
  }

  # Filter out null values from cost allocation tags
  filtered_cost_allocation_tags = {
    for key, value in local.cost_allocation_tags : key => value
    if value != null
  }
  
  # Secret names with prefix
  key_name_secret_name = var.key_name_secret_name != null ? "${var.secrets_prefix}${var.key_name_secret_name}" : null
  user_data_secret_name = var.user_data_secret_name != null ? "${var.secrets_prefix}${var.user_data_secret_name}" : null
  root_volume_kms_key_id_secret_name = var.root_volume_kms_key_id_secret_name != null ? "${var.secrets_prefix}${var.root_volume_kms_key_id_secret_name}" : null
}

# Create a security group for the EC2 instance if needed
resource "aws_security_group" "instance" {
  count       = var.create_security_group ? 1 : 0
  name        = "${var.instance_name}-sg"
  description = "Security group for ${var.instance_name} EC2 instance"
  vpc_id      = var.vpc_id

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_blocks
    description = "SSH access"
  }

  # HTTP access if needed
  dynamic "ingress" {
    for_each = var.enable_http_access ? [1] : []
    content {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = var.http_cidr_blocks
      description = "HTTP access"
    }
  }

  # HTTPS access if needed
  dynamic "ingress" {
    for_each = var.enable_https_access ? [1] : []
    content {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = var.https_cidr_blocks
      description = "HTTPS access"
    }
  }

  # Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    {
      Name        = "${var.instance_name}-sg"
      Environment = var.environment
      Terraform   = "true"
    },
    var.additional_tags,
    local.filtered_cost_allocation_tags
  )
}

# AWS Secrets Manager modules for retrieving sensitive data
module "key_name_secret" {
  source      = "./modules/secrets_manager"
  count       = var.use_secrets_manager && local.key_name_secret_name != null ? 1 : 0
  
  create_secret = var.create_secrets
  secret_name   = local.key_name_secret_name
  secret_string = var.create_secrets ? var.key_name : null
}

module "user_data_secret" {
  source      = "./modules/secrets_manager"
  count       = var.use_secrets_manager && local.user_data_secret_name != null ? 1 : 0
  
  create_secret = var.create_secrets
  secret_name   = local.user_data_secret_name
  secret_string = var.create_secrets ? var.user_data : null
}

module "root_volume_kms_key_id_secret" {
  source      = "./modules/secrets_manager"
  count       = var.use_secrets_manager && local.root_volume_kms_key_id_secret_name != null ? 1 : 0
  
  create_secret = var.create_secrets
  secret_name   = local.root_volume_kms_key_id_secret_name
  secret_string = var.create_secrets ? var.root_volume_kms_key_id : null
}

# Use our custom EC2 instance module for single instance deployment
module "ec2_instance" {
  source = "./modules/ec2_instance"
  count  = var.enable_autoscaling ? 0 : 1

  name                        = var.instance_name
  ami_id                      = var.ami_id
  instance_type               = local.selected_instance_type
  subnet_id                   = var.subnet_id
  security_group_ids          = var.create_security_group ? concat(var.security_group_ids, [aws_security_group.instance[0].id]) : var.security_group_ids
  key_name                    = var.use_secrets_manager && local.key_name_secret_name != null ? module.key_name_secret[0].secret_value : var.key_name
  associate_public_ip_address = var.associate_public_ip_address
  create_elastic_ip           = var.create_elastic_ip

  root_volume_size            = var.root_volume_size
  root_volume_type            = var.root_volume_type
  root_volume_encrypted       = var.root_volume_encrypted
  root_volume_kms_key_id      = var.use_secrets_manager && local.root_volume_kms_key_id_secret_name != null ? module.root_volume_kms_key_id_secret[0].secret_value : var.root_volume_kms_key_id

  user_data                   = var.use_secrets_manager && local.user_data_secret_name != null ? module.user_data_secret[0].secret_value : var.user_data

  # IMDSv2 is more secure and recommended by AWS
  metadata_http_tokens        = "required"

  # Enable detailed monitoring if specified
  enable_detailed_monitoring  = var.enable_detailed_monitoring

  tags = merge(
    {
      Name        = var.instance_name
      Environment = var.environment
      Terraform   = "true"
    },
    var.additional_tags,
    local.filtered_cost_allocation_tags
  )

  volume_tags = merge(
    {
      Name        = var.instance_name
      Environment = var.environment
      Terraform   = "true"
    },
    var.additional_tags,
    local.filtered_cost_allocation_tags
  )
}

# Use our custom Auto Scaling Group module for autoscaling deployment
module "autoscaling" {
  source = "./modules/autoscaling"
  count  = var.enable_autoscaling ? 1 : 0

  name                        = var.instance_name
  ami_id                      = var.ami_id
  instance_type               = local.selected_instance_type
  subnet_ids                  = var.subnet_ids
  security_group_ids          = var.create_security_group ? concat(var.security_group_ids, [aws_security_group.instance[0].id]) : var.security_group_ids
  key_name                    = var.use_secrets_manager && local.key_name_secret_name != null ? module.key_name_secret[0].secret_value : var.key_name

  # Right-sizing configuration
  override_instance_types     = local.selected_override_instance_types
  use_spot_instances          = var.use_spot_instances
  spot_price                  = var.spot_price
  on_demand_base_capacity     = var.on_demand_base_capacity
  on_demand_percentage_above_base_capacity = var.on_demand_percentage_above_base_capacity

  # Auto Scaling configuration
  min_size                    = var.min_size
  max_size                    = var.max_size
  desired_capacity            = var.desired_capacity
  health_check_type           = var.health_check_type
  target_group_arns           = var.target_group_arns

  # Scaling policies
  enable_scaling_policies     = var.enable_scaling_policies
  high_cpu_threshold          = var.high_cpu_threshold
  low_cpu_threshold           = var.low_cpu_threshold

  # Volume configuration
  root_volume_size            = var.root_volume_size
  root_volume_type            = var.root_volume_type
  root_volume_encrypted       = var.root_volume_encrypted
  root_volume_kms_key_id      = var.use_secrets_manager && local.root_volume_kms_key_id_secret_name != null ? module.root_volume_kms_key_id_secret[0].secret_value : var.root_volume_kms_key_id

  user_data                   = var.use_secrets_manager && local.user_data_secret_name != null ? module.user_data_secret[0].secret_value : var.user_data

  # Monitoring
  enable_detailed_monitoring  = var.enable_detailed_monitoring

  # Tagging
  tags = merge(
    {
      Name        = var.instance_name
      Environment = var.environment
      Terraform   = "true"
    },
    var.additional_tags
  )

  volume_tags = merge(
    {
      Name        = var.instance_name
      Environment = var.environment
      Terraform   = "true"
    },
    var.additional_tags
  )

  # Cost allocation tagging
  cost_allocation_tags = local.filtered_cost_allocation_tags
}