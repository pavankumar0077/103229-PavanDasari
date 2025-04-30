/**
 * # Complete Example
 *
 * This example demonstrates how to use the EC2 module with right-sizing, autoscaling, and cost tracking.
 */

provider "aws" {
  region = "us-west-2"
}

# Get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Example 1: Single EC2 instance with right-sizing and cost tracking
module "single_instance" {
  source = "../../"

  instance_name = "example-single-instance"
  ami_id        = data.aws_ami.amazon_linux.id

  # Right-sizing
  workload_profile = "medium"  # Will use t3.medium or equivalent

  # Network configuration
  subnet_id                   = "subnet-12345678"
  vpc_id                      = "vpc-12345678"
  associate_public_ip_address = true
  create_elastic_ip           = true

  # Security
  create_security_group = true
  enable_http_access    = true
  enable_https_access   = true

  # Cost tracking tags
  cost_center   = "IT-123"
  project       = "Example Project"
  owner         = "DevOps Team"
  business_unit = "Engineering"

  # Additional tags
  environment = "dev"
  additional_tags = {
    ManagedBy = "Terraform"
    Backup    = "true"
  }
}

# Example 2: Auto Scaling Group with right-sizing and cost tracking
module "autoscaling_instance" {
  source = "../../"

  instance_name = "example-autoscaling"
  ami_id        = data.aws_ami.amazon_linux.id

  # Enable autoscaling
  enable_autoscaling = true

  # Right-sizing
  workload_profile = "compute-optimized"  # Will use c5.large or equivalent

  # Use spot instances for cost optimization
  use_spot_instances = true

  # Mixed instance types for right-sizing
  override_instance_types = ["c5.large", "c5a.large", "c5n.large", "c4.large"]

  # Auto Scaling configuration
  min_size         = 2
  max_size         = 10
  desired_capacity = 2

  # Enable scaling policies
  enable_scaling_policies = true
  high_cpu_threshold      = 75
  low_cpu_threshold       = 25

  # Network configuration
  subnet_ids = ["subnet-12345678", "subnet-87654321"]
  vpc_id     = "vpc-12345678"

  # Security
  create_security_group = true
  enable_http_access    = true
  enable_https_access   = true

  # Monitoring
  enable_detailed_monitoring = true

  # Cost tracking tags
  cost_center   = "IT-456"
  project       = "Example Autoscaling Project"
  owner         = "DevOps Team"
  business_unit = "Engineering"

  # Additional tags
  environment = "prod"
  additional_tags = {
    ManagedBy = "Terraform"
    Backup    = "true"
  }
}