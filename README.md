# Terraform AWS EC2 Instance

This repository contains Terraform configurations to deploy EC2 instances on AWS following best practices, with support for right-sizing, autoscaling, and cost tracking.

## Project Structure

```
.
├── README.md                 # Project documentation
├── main.tf                   # Root module configuration
├── variables.tf              # Input variables
├── outputs.tf                # Output values
├── terraform.tfvars.example  # Example variable values
├── backend.tf                # State configuration
├── providers.tf              # Provider configuration
├── .github/                  # GitHub specific files
│   ├── workflows/            # GitHub Actions workflows
│   │   ├── terraform-cicd.yml # CI/CD pipeline for Terraform
│   │   ├── security-scan.yml  # Security scanning workflow
│   │   └── code-quality.yml   # Code quality checks workflow
│   └── CICD_USAGE_GUIDE.md   # Guide for using CI/CD pipelines
├── modules/                  # Reusable modules
│   ├── ec2_instance/         # EC2 instance module
│   └── autoscaling/          # Auto Scaling Group module
├── examples/                 # Example configurations
│   └── complete/             # Complete example with all features
└── environments/             # Environment-specific configurations
    ├── dev/                  # Development environment
    └── prod/                 # Production environment
```

## Features

- **Modular Design**: Reusable EC2 instance and Auto Scaling Group modules
- **Right-Sizing**: Predefined workload profiles and instance type selection
- **Autoscaling**: Dynamic capacity adjustment based on demand
- **Cost Tracking**: Comprehensive tagging for cost allocation
- **Spot Instances**: Support for cost optimization with Spot Instances
- **State Management**: Remote state configuration with locking
- **Environment Support**: Separate configurations for development and production
- **Security Best Practices**: Secure configuration for EC2 instances
- **CI/CD Pipeline**: Automated workflows for validation, security scanning, and deployment
- **Code Quality**: Automated checks for code formatting and best practices
- **Security Scanning**: Multiple security scanning tools to identify vulnerabilities

## Prerequisites

- Terraform v1.0.0+
- AWS CLI configured with appropriate credentials
- S3 bucket for remote state storage
- DynamoDB table for state locking

## Usage

### Basic Usage (Single Instance)

```hcl
module "ec2_instance" {
  source = "path/to/module"

  instance_name = "web-server"
  ami_id        = "ami-12345678"
  subnet_id     = "subnet-12345678"
  vpc_id        = "vpc-12345678"
  
  # Right-sizing
  workload_profile = "medium"  # Will use t3.medium or equivalent
  
  # Cost tracking tags
  cost_center   = "IT-123"
  project       = "Web Application"
  owner         = "DevOps Team"
  business_unit = "Engineering"
}
```

### Autoscaling Usage

```hcl
module "web_servers" {
  source = "path/to/module"

  instance_name = "web-servers"
  ami_id        = "ami-12345678"
  
  # Enable autoscaling
  enable_autoscaling = true
  subnet_ids         = ["subnet-12345678", "subnet-87654321"]
  vpc_id             = "vpc-12345678"
  
  # Right-sizing
  workload_profile = "compute-optimized"
  
  # Auto Scaling configuration
  min_size         = 2
  max_size         = 10
  desired_capacity = 2
  
  # Enable scaling policies
  enable_scaling_policies = true
  high_cpu_threshold      = 75
  low_cpu_threshold       = 25
  
  # Cost tracking tags
  cost_center   = "IT-456"
  project       = "Web Application"
  owner         = "DevOps Team"
  business_unit = "Engineering"
}
```

## Right-Sizing

The module supports predefined workload profiles to help with right-sizing:

- `small`: Suitable for low-traffic applications (t3.micro or equivalent)
- `medium`: Suitable for moderate-traffic applications (t3.medium or equivalent)
- `large`: Suitable for high-traffic applications (t3.large or equivalent)
- `xlarge`: Suitable for very high-traffic applications (t3.xlarge or equivalent)
- `compute-optimized`: Suitable for compute-intensive workloads (c5.large or equivalent)
- `memory-optimized`: Suitable for memory-intensive workloads (r5.large or equivalent)

You can also specify custom instance types using the `instance_type` and `override_instance_types` variables.

## Autoscaling

The module supports AWS Auto Scaling Groups with the following features:

- Dynamic capacity adjustment based on CPU utilization
- Support for mixed instance types
- Support for Spot Instances for cost optimization
- CloudWatch alarms for scaling triggers
- Health checks and instance refresh

## Cost Tracking

The module supports comprehensive tagging for cost allocation:

- `CostCenter`: Cost center for accounting purposes
- `Project`: Project name for cost allocation
- `Owner`: Owner of the resources
- `BusinessUnit`: Business unit for cost allocation

## Module Documentation

See the README in each module directory for specific usage instructions and input/output variables.

## Examples

See the `examples/complete` directory for a complete example with all features.

## Getting Started

1. Clone this repository
2. Navigate to the desired environment directory (`environments/dev` or `environments/prod`)
3. Initialize Terraform:
   ```
   terraform init
   ```
4. Review the execution plan:
   ```
   terraform plan
   ```
5. Apply the configuration:
   ```
   terraform apply
   ```

## CI/CD Pipeline

This repository includes GitHub Actions workflows for CI/CD:

1. **Terraform CI/CD Pipeline**: Validates, plans, and applies Terraform configurations
2. **Security Scanning**: Performs security scanning using multiple tools
3. **Code Quality**: Ensures code quality standards are maintained

For detailed information on using these workflows, see [CICD_USAGE_GUIDE.md](.github/CICD_USAGE_GUIDE.md).
