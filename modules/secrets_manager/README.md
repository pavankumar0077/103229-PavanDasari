# AWS Secrets Manager Module

This module creates and manages AWS Secrets Manager secrets for storing sensitive data.

## Features

- Create new secrets or use existing ones
- Store string values or JSON key-value pairs
- Retrieve secret values for use in other resources
- Support for custom KMS keys for encryption
- Support for custom recovery window

## Usage

### Creating a new secret with a string value

```hcl
module "db_password_secret" {
  source = "./modules/secrets_manager"

  create_secret   = true
  secret_name     = "db-password"
  secret_string   = "supersecretpassword"
}
```

### Creating a new secret with JSON key-value pairs

```hcl
module "db_credentials_secret" {
  source = "./modules/secrets_manager"

  create_secret   = true
  secret_name     = "db-credentials"
  secret_key_value_map = {
    username = "admin"
    password = "supersecretpassword"
    host     = "db.example.com"
    port     = "5432"
  }
}
```

### Using an existing secret

```hcl
module "existing_secret" {
  source = "./modules/secrets_manager"

  create_secret   = false
  secret_name     = "existing-secret-name"
  parse_json_value = true  # If the secret is stored as JSON
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_secret | Whether to create a new secret or use an existing one | `bool` | `false` | no |
| secret_name | Name of the secret in AWS Secrets Manager | `string` | n/a | yes |
| secret_description | Description of the secret | `string` | `"Managed by Terraform"` | no |
| secret_string | Text to store in the secret. Cannot be used with secret_key_value_map | `string` | `null` | no |
| secret_key_value_map | Map of key/value pairs to store as JSON in the secret. Cannot be used with secret_string | `map(string)` | `{}` | no |
| kms_key_id | ARN or ID of the AWS KMS key to be used to encrypt the secret | `string` | `null` | no |
| recovery_window_in_days | Number of days that AWS Secrets Manager waits before it can delete the secret | `number` | `30` | no |
| parse_json_value | Whether to parse the secret value as JSON | `bool` | `false` | no |
| tags | A mapping of tags to assign to the secret | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| secret_id | The ID of the secret |
| secret_arn | The ARN of the secret |
| secret_value | The secret value |
| secret_json_value | The secret value parsed as JSON (if parse_json_value is true) |