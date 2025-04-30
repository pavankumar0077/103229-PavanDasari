/**
 * # Production Environment EC2 Instance
 *
 * This configuration deploys an EC2 instance or Auto Scaling Group for the production environment
 * with enhanced security, performance settings, right-sizing, autoscaling, and cost tracking.
 */

terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "environments/prod/ec2-instance/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Environment = "Production"
    }
  }
}

module "ec2_instance_prod" {
  source = "../../"  # Root module

  # Instance configuration
  instance_name = "${var.project_name}-prod-instance"
  ami_id        = var.ami_id

  # Right-sizing
  workload_profile = var.workload_profile
  instance_type    = var.instance_type  # Larger instance for production

  # Network configuration
  subnet_id                   = var.subnet_id
  subnet_ids                  = var.subnet_ids
  vpc_id                      = var.vpc_id
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip_address
  create_elastic_ip           = var.create_elastic_ip

  # Storage configuration
  root_volume_size      = 50  # Larger volume for production
  root_volume_type      = "gp3"
  root_volume_encrypted = true

  # Security configuration - more restrictive for production
  create_security_group = true
  ssh_cidr_blocks       = var.ssh_cidr_blocks  # More restricted in production
  enable_http_access    = var.enable_http_access
  http_cidr_blocks      = var.http_cidr_blocks
  enable_https_access   = var.enable_https_access
  https_cidr_blocks     = var.https_cidr_blocks

  # Autoscaling configuration
  enable_autoscaling      = var.enable_autoscaling
  min_size                = var.min_size
  max_size                = var.max_size
  desired_capacity        = var.desired_capacity
  enable_scaling_policies = var.enable_scaling_policies
  high_cpu_threshold      = var.high_cpu_threshold
  low_cpu_threshold       = var.low_cpu_threshold
  health_check_type       = var.health_check_type
  target_group_arns       = var.target_group_arns

  # Cost optimization
  use_spot_instances                       = var.use_spot_instances
  spot_price                               = var.spot_price
  on_demand_base_capacity                  = var.on_demand_base_capacity
  on_demand_percentage_above_base_capacity = var.on_demand_percentage_above_base_capacity
  override_instance_types                  = var.override_instance_types

  # Monitoring
  enable_detailed_monitoring = true

  # Cost tracking
  environment   = "prod"
  cost_center   = var.cost_center
  project       = var.project_name
  owner         = var.owner
  business_unit = var.business_unit

  # Additional tags
  additional_tags = merge(
    var.additional_tags,
    {
      Backup     = "true"
      Compliance = "PCI-DSS"
    }
  )
}