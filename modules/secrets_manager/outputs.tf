output "secret_id" {
  description = "The ID of the secret"
  value       = local.secret_id
}

output "secret_arn" {
  description = "The ARN of the secret"
  value       = var.create_secret ? (length(aws_secretsmanager_secret.this) > 0 ? aws_secretsmanager_secret.this[0].arn : null) : (length(data.aws_secretsmanager_secret.existing) > 0 ? data.aws_secretsmanager_secret.existing[0].arn : null)
}

output "secret_value" {
  description = "The secret value"
  value       = local.secret_value
  sensitive   = true
}

output "secret_json_value" {
  description = "The secret value parsed as JSON (if parse_json_value is true)"
  value       = local.parsed_secret_value
  sensitive   = true
}