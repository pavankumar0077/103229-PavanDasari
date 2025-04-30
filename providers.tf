/**
 * # AWS Provider Configuration
 *
 * This file configures the AWS provider for Terraform.
 */

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.aws_region
  
  # Optional provider settings
  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Repository  = "terraform-aws-ec2-instance"
    }
  }
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}