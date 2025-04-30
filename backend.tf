/**
 * # Terraform State Configuration
 *
 * This file configures the backend for storing Terraform state.
 * Using S3 for state storage and DynamoDB for state locking.
 */

terraform {
  backend "s3" {
    # Replace these with your actual values
    bucket         = "your-terraform-state-bucket"
    key            = "ec2-instance/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

# Note: Variables cannot be used in the backend configuration.
# If you need to parameterize the backend, use partial configuration:
# https://www.terraform.io/docs/language/settings/backends/configuration.html#partial-configuration