# Terraform AWS EC2 Instance - Usage Guide

This guide explains how to use the Terraform template to deploy EC2 instances following best practices.

## Repository Structure

```
.
├── README.md                 # Project documentation
├── main.tf                   # Root module configuration
├── variables.tf              # Input variables
├── outputs.tf                # Output values
├── terraform.tfvars.example  # Example variable values
├── backend.tf                # State configuration
├── providers.tf              # Provider configuration
├── modules/                  # Reusable modules
│   └── ec2_instance/         # EC2 instance module
└── environments/             # Environment-specific configurations
    ├── dev/                  # Development environment
    └── prod/                 # Production environment
```

## Getting Started

### Prerequisites

1. Install Terraform (v1.0.0+)
2. Configure AWS CLI with appropriate credentials
3. Create an S3 bucket for remote state storage
4. Create a DynamoDB table for state locking

### Initial Setup

1. Clone this repository
2. Update the backend configuration in `backend.tf` and in each environment's `main.tf` file:
   ```hcl
   terraform {
     backend "s3" {
       bucket         = "your-terraform-state-bucket"  # Replace with your bucket name
       key            = "ec2-instance/terraform.tfstate"
       region         = "us-west-2"  # Replace with your region
       encrypt        = true
       dynamodb_table = "terraform-state-lock"  # Replace with your DynamoDB table name
     }
   }
   ```

3. Create a `terraform.tfvars` file based on the example file:
   ```
   cp terraform.tfvars.example terraform.tfvars
   ```

4. Update the variable values in `terraform.tfvars` with your specific configuration

### Deploying to Different Environments

#### Development Environment

```bash
cd environments/dev
# Update terraform.tfvars with your values
terraform init
terraform plan
terraform apply
```

#### Production Environment

```bash
cd environments/prod
# Update terraform.tfvars with your values
terraform init
terraform plan
terraform apply
```

## Customizing the EC2 Instance

The EC2 instance can be customized by modifying the variables in the environment-specific `terraform.tfvars` files:

### Basic Configuration

```hcl
instance_name = "app-server"
ami_id        = "ami-0c55b159cbfafe1f0"  # Replace with your AMI ID
instance_type = "t3.micro"
subnet_id     = "subnet-0123456789abcdef0"  # Replace with your subnet ID
vpc_id        = "vpc-0123456789abcdef0"      # Replace with your VPC ID
key_name      = "your-key-pair"              # Replace with your key pair name
```

### Security Configuration

```hcl
create_security_group = true
ssh_cidr_blocks       = ["10.0.0.0/16"]  # Restrict SSH access to specific IP ranges
enable_http_access    = true
http_cidr_blocks      = ["0.0.0.0/0"]
enable_https_access   = true
https_cidr_blocks     = ["0.0.0.0/0"]
```

### Storage Configuration

```hcl
root_volume_size     = 30
root_volume_type     = "gp3"
root_volume_encrypted = true
```

## Best Practices Implemented

This template follows several Terraform and AWS best practices:

1. **Code Modularity**
   - Reusable EC2 instance module
   - Separation of environment-specific configurations
   - Clear variable definitions and outputs

2. **State Management**
   - Remote state storage in S3
   - State locking with DynamoDB
   - Separate state files for different environments

3. **Security**
   - IMDSv2 required by default
   - Root volume encryption enabled by default
   - Environment-specific security group rules
   - Restricted SSH access

4. **Environment Separation**
   - Different configurations for development and production
   - Production has more restrictive security settings
   - Development allows for easier testing and debugging

## Extending the Template

To extend this template for additional requirements:

1. **Adding More Resources**
   - Create additional modules in the `modules/` directory
   - Reference them from the root module or environment-specific configurations

2. **Supporting More Environments**
   - Copy an existing environment directory (e.g., `environments/dev/`)
   - Rename it to your new environment (e.g., `environments/staging/`)
   - Update the configuration as needed

3. **Adding Custom User Data**
   - Create a user data script
   - Reference it in the environment's `terraform.tfvars` file:
     ```hcl
     user_data = file("${path.module}/user-data.sh")
     ```

## Troubleshooting

### Common Issues

1. **Backend Initialization Failure**
   - Ensure the S3 bucket and DynamoDB table exist
   - Verify AWS credentials have appropriate permissions

2. **Resource Creation Failure**
   - Check that the specified VPC, subnet, and security groups exist
   - Verify the AMI ID is valid for the selected region

3. **SSH Access Issues**
   - Ensure the key pair exists in the AWS region
   - Verify security group rules allow SSH from your IP address

For additional help, refer to the [Terraform documentation](https://www.terraform.io/docs) or [AWS EC2 documentation](https://docs.aws.amazon.com/ec2/).