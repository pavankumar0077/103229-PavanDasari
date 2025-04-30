# AWS Auto Scaling Group Module

This module creates an Auto Scaling Group with configurable parameters following AWS best practices for right-sizing and cost optimization.

## Features

- **Right-sizing**: Supports mixed instance types to optimize for cost and performance
- **Auto Scaling**: Automatically adjusts capacity based on demand using CloudWatch alarms
- **Cost Tracking**: Includes comprehensive tagging for cost allocation and tracking
- **Spot Instances**: Optional support for Spot Instances to reduce costs
- **Instance Refresh**: Support for rolling updates of instances

## Usage

```hcl
module "autoscaling" {
  source = "./modules/autoscaling"

  name       = "web-servers"
  ami_id     = "ami-12345678"
  subnet_ids = ["subnet-12345678", "subnet-87654321"]
  
  # Right-sizing configuration
  instance_type          = "t3.micro"
  override_instance_types = ["t3.micro", "t3a.micro", "t2.micro"]
  on_demand_base_capacity = 1
  on_demand_percentage_above_base_capacity = 50
  spot_allocation_strategy = "capacity-optimized"
  
  # Auto Scaling configuration
  min_size         = 2
  max_size         = 10
  desired_capacity = 2
  
  # Enable scaling policies
  enable_scaling_policies = true
  high_cpu_threshold      = 75
  low_cpu_threshold       = 25
  
  # Cost allocation tags
  cost_allocation_tags = {
    Environment     = "Production"
    CostCenter      = "IT-123"
    Project         = "WebApp"
    Owner           = "DevOps"
    BusinessUnit    = "Digital"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Name to be used for the Auto Scaling Group and related resources | `string` | n/a | yes |
| ami_id | ID of AMI to use for the instances | `string` | n/a | yes |
| subnet_ids | A list of subnet IDs to launch resources in | `list(string)` | n/a | yes |
| instance_type | The primary instance type to use for the Auto Scaling Group | `string` | `"t3.micro"` | no |
| min_size | Minimum size of the Auto Scaling Group | `number` | `1` | no |
| max_size | Maximum size of the Auto Scaling Group | `number` | `3` | no |
| desired_capacity | Desired capacity of the Auto Scaling Group | `number` | `1` | no |
| ... | ... | ... | ... | ... |

## Outputs

| Name | Description |
|------|-------------|
| autoscaling_group_id | The ID of the Auto Scaling Group |
| autoscaling_group_name | The name of the Auto Scaling Group |
| autoscaling_group_arn | The ARN of the Auto Scaling Group |
| launch_template_id | The ID of the launch template |
| ... | ... |