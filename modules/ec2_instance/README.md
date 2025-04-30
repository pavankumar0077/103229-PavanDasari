# EC2 Instance Terraform Module

This Terraform module creates an EC2 instance with configurable parameters following AWS best practices.

## Features

- Configurable instance type, AMI, and networking
- Optional Elastic IP association
- Enhanced security with IMDSv2 by default
- Root volume encryption by default
- Detailed monitoring option
- Comprehensive tagging support

## Usage

```hcl
module "ec2_instance" {
  source = "../../modules/ec2_instance"

  name                        = "app-server"
  ami_id                      = "ami-0c55b159cbfafe1f0"
  instance_type               = "t3.micro"
  subnet_id                   = "subnet-abcde123"
  security_group_ids          = ["sg-12345678"]
  key_name                    = "my-key-pair"
  associate_public_ip_address = true
  create_elastic_ip           = true
  
  root_volume_size            = 30
  root_volume_type            = "gp3"
  
  tags = {
    Environment = "dev"
    Project     = "example"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | >= 4.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name to be used on EC2 instance created | `string` | n/a | yes |
| ami_id | ID of AMI to use for the instance | `string` | n/a | yes |
| instance_type | The type of instance to start | `string` | `"t3.micro"` | no |
| subnet_id | The VPC Subnet ID to launch in | `string` | n/a | yes |
| security_group_ids | A list of security group IDs to associate with | `list(string)` | `[]` | no |
| key_name | Key name of the Key Pair to use for the instance | `string` | `null` | no |
| iam_instance_profile | IAM Instance Profile to launch the instance with | `string` | `null` | no |
| user_data | The user data to provide when launching the instance | `string` | `null` | no |
| user_data_base64 | Can be used instead of user_data to pass base64-encoded binary data directly | `string` | `null` | no |
| associate_public_ip_address | Whether to associate a public IP address with an instance in a VPC | `bool` | `false` | no |
| create_elastic_ip | Whether to create an Elastic IP for the instance | `bool` | `false` | no |
| root_volume_type | The type of volume. Can be 'standard', 'gp2', 'gp3', 'io1', 'io2', 'sc1', or 'st1' | `string` | `"gp3"` | no |
| root_volume_size | The size of the volume in gigabytes | `number` | `20` | no |
| root_volume_delete_on_termination | Whether the volume should be destroyed on instance termination | `bool` | `true` | no |
| root_volume_encrypted | Whether to enable volume encryption | `bool` | `true` | no |
| root_volume_kms_key_id | Amazon Resource Name (ARN) of the KMS Key to use when encrypting the volume | `string` | `null` | no |
| tags | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |
| volume_tags | A mapping of tags to assign to the volumes | `map(string)` | `{}` | no |
| metadata_http_endpoint | Whether the metadata service is available. Can be 'enabled' or 'disabled' | `string` | `"enabled"` | no |
| metadata_http_tokens | Whether or not the metadata service requires session tokens (IMDSv2) | `string` | `"required"` | no |
| metadata_http_put_response_hop_limit | The desired HTTP PUT response hop limit for instance metadata requests | `number` | `1` | no |
| enable_detailed_monitoring | Whether to enable detailed monitoring | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the instance |
| arn | The ARN of the instance |
| instance_state | The state of the instance |
| private_ip | The private IP address assigned to the instance |
| public_ip | The public IP address assigned to the instance, if applicable |
| elastic_ip | The Elastic IP address assigned to the instance, if applicable |
| elastic_ip_id | The allocation ID of the Elastic IP address, if applicable |
| primary_network_interface_id | The ID of the instance's primary network interface |
| security_groups | The security groups associated with the instance |
| subnet_id | The subnet ID the instance was launched in |
| tags_all | A map of tags assigned to the resource |