/**
 * # AWS Secrets Manager Module
 *
 * This module creates and manages AWS Secrets Manager secrets for storing sensitive data.
 */

# Create a new secret
resource "aws_secretsmanager_secret" "this" {
  count                   = var.create_secret ? 1 : 0
  name                    = var.secret_name
  description             = var.secret_description
  kms_key_id              = var.kms_key_id
  recovery_window_in_days = var.recovery_window_in_days
  
  tags = merge(
    {
      Name = var.secret_name
    },
    var.tags
  )
}

# Store the secret value
resource "aws_secretsmanager_secret_version" "this" {
  count         = var.create_secret && var.secret_string != null ? 1 : 0
  secret_id     = aws_secretsmanager_secret.this[0].id
  secret_string = var.secret_string
}

# Store the secret value as JSON
resource "aws_secretsmanager_secret_version" "json" {
  count     = var.create_secret && var.secret_string == null && length(var.secret_key_value_map) > 0 ? 1 : 0
  secret_id = aws_secretsmanager_secret.this[0].id
  secret_string = jsonencode(var.secret_key_value_map)
}

# Data source to retrieve an existing secret
data "aws_secretsmanager_secret" "existing" {
  count = var.create_secret ? 0 : 1
  name  = var.secret_name
}

data "aws_secretsmanager_secret_version" "existing" {
  count     = var.create_secret ? 0 : 1
  secret_id = data.aws_secretsmanager_secret.existing[0].id
}

locals {
  # If we're creating a secret, use that secret's ID, otherwise use the existing secret's ID
  secret_id = var.create_secret ? (length(aws_secretsmanager_secret.this) > 0 ? aws_secretsmanager_secret.this[0].id : null) : (length(data.aws_secretsmanager_secret.existing) > 0 ? data.aws_secretsmanager_secret.existing[0].id : null)
  
  # Get the secret value
  secret_value = var.create_secret ? (
    var.secret_string != null ? var.secret_string : (
      length(var.secret_key_value_map) > 0 ? jsonencode(var.secret_key_value_map) : null
    )
  ) : (
    length(data.aws_secretsmanager_secret_version.existing) > 0 ? data.aws_secretsmanager_secret_version.existing[0].secret_string : null
  )
  
  # Parse JSON secret value if needed
  parsed_secret_value = var.parse_json_value ? (
    local.secret_value != null ? jsondecode(local.secret_value) : {}
  ) : null
}