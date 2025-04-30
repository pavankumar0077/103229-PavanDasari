/**
 * # Development Environment EC2 Instance
 *
 * This configuration deploys an EC2 instance for the development environment
 * with right-sizing, autoscaling, and cost tracking.
 */

terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "environments/dev/ec2-instance/terraform.tfstate"
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
      Environment = "Development"
    }
  }
}

module "ec2_instance_dev" {
  source = "../../"  # Root module
  
  # Instance configuration
  instance_name = "${var.project_name}-dev-instance"
  ami_id        = var.ami_id
  
  # Right-sizing
  workload_profile = var.workload_profile
  instance_type    = var.instance_type
  
  # Network configuration
  subnet_id                   = var.subnet_id
  subnet_ids                  = var.subnet_ids
  vpc_id                      = var.vpc_id
  key_name                    = var.key_name
  associate_public_ip_address = true
  create_elastic_ip           = true
  
  # Storage configuration
  root_volume_size      = 20
  root_volume_type      = "gp3"
  root_volume_encrypted = true
  
  # Security configuration
  create_security_group = true
  ssh_cidr_blocks       = var.ssh_cidr_blocks
  enable_http_access    = true
  http_cidr_blocks      = var.http_cidr_blocks
  enable_https_access   = true
  https_cidr_blocks     = var.https_cidr_blocks
  
  # Autoscaling configuration
  enable_autoscaling      = var.enable_autoscaling
  min_size                = var.min_size
  max_size                = var.max_size
  desired_capacity        = var.desired_capacity
  enable_scaling_policies = var.enable_scaling_policies
  high_cpu_threshold      = var.high_cpu_threshold
  low_cpu_threshold       = var.low_cpu_threshold
  
  # Cost optimization
  use_spot_instances    = var.use_spot_instances
  spot_price            = var.spot_price
  
  # Monitoring
  enable_detailed_monitoring = true
  
  # Cost tracking
  environment   = "dev"
  cost_center   = var.cost_center
  project       = var.project_name  # Mapping project_name to project variable expected by root module
  owner         = var.owner
  business_unit = var.business_unit
  
  # Additional tags
  additional_tags = var.additional_tags
}