# CI/CD Pipeline Usage Guide

This guide explains how to use the GitHub Actions workflows for CI/CD, code quality checks, and security scanning in this Terraform AWS EC2 Instance project.

## Workflow Overview

This repository includes three main GitHub Actions workflows:

1. **Terraform CI/CD Pipeline** (`terraform-cicd.yml`): Handles validation, planning, and applying Terraform configurations.
2. **Security Scanning** (`security-scan.yml`): Performs comprehensive security scanning of the codebase.
3. **Code Quality** (`code-quality.yml`): Ensures code quality standards are maintained.

## Prerequisites

Before using these workflows, you need to set up the following:

1. **AWS IAM Role for GitHub Actions**:
   - Create an IAM role in your AWS account with appropriate permissions
   - Configure OIDC provider in AWS to trust GitHub Actions
   - Store the role ARN as a GitHub secret

2. **GitHub Secrets**:
   - `AWS_ROLE_TO_ASSUME`: The ARN of the IAM role to assume (e.g., `arn:aws:iam::123456789012:role/github-actions-role`)

## Setting Up AWS OIDC Authentication

For secure, keyless authentication to AWS, we use OpenID Connect (OIDC):

1. Create an OIDC provider in AWS IAM:
   ```
   aws iam create-open-id-connect-provider \
     --url https://token.actions.githubusercontent.com \
     --client-id-list sts.amazonaws.com \
     --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1
   ```

2. Create an IAM role with the following trust policy:
   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Allow",
         "Principal": {
           "Federated": "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"
         },
         "Action": "sts:AssumeRoleWithWebIdentity",
         "Condition": {
           "StringEquals": {
             "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
           },
           "StringLike": {
             "token.actions.githubusercontent.com:sub": "repo:your-org/your-repo:*"
           }
         }
       }
     ]
   }
   ```

3. Attach the necessary AWS managed policies to this role:
   - `AmazonS3ReadOnlyAccess` (for Terraform state)
   - `AmazonDynamoDBReadOnlyAccess` (for state locking)
   - Custom policy for your specific Terraform resources

## Managing Secrets

This project uses GitHub Secrets for managing sensitive information:

1. **Repository Secrets**:
   - Navigate to your GitHub repository → Settings → Secrets and variables → Actions
   - Add the following secrets:
     - `AWS_ROLE_TO_ASSUME`: ARN of the IAM role for GitHub Actions

2. **Environment Secrets**:
   - For environment-specific secrets, create environments in GitHub:
     - Go to Settings → Environments → New environment
     - Create environments for `dev` and `prod`
     - Add environment-specific secrets as needed

3. **Best Practices**:
   - Never hardcode secrets in your Terraform code
   - Use GitHub environments for approval workflows
   - Rotate credentials regularly
   - Limit permissions to the minimum required

## Using the Workflows

### Terraform CI/CD Pipeline

This workflow runs automatically on:
- Push to `main` branch (affecting `.tf` or `.tfvars` files)
- Pull requests to `main` branch
- Manual trigger via workflow_dispatch

For manual deployment:
1. Go to Actions → Terraform CI/CD Pipeline → Run workflow
2. Select the branch and environment (dev/prod)
3. Click "Run workflow"

### Security Scanning

This workflow runs:
- On push to `main` branch
- On pull requests to `main` branch
- Weekly on Sundays (scheduled)
- Manual trigger

It includes:
- TFSec for Terraform security scanning
- Checkov for policy compliance
- Terrascan for additional security checks
- CodeQL for code analysis
- Secret scanning with TruffleHog

### Code Quality

This workflow runs on:
- Push to `main` branch (affecting `.tf` or `.md` files)
- Pull requests to `main` branch
- Manual trigger

It includes:
- Terraform format checking
- TFLint for Terraform linting
- Markdown linting
- Terraform documentation generation
- Terraform validation

## Workflow Customization

To customize these workflows:

1. Edit the workflow files in `.github/workflows/`
2. Adjust the triggers, jobs, or steps as needed
3. Commit and push your changes

## Troubleshooting

Common issues and solutions:

1. **Authentication Failures**:
   - Verify the `AWS_ROLE_TO_ASSUME` secret is correctly set
   - Check that the IAM role has the necessary permissions
   - Ensure the OIDC trust relationship is properly configured

2. **Terraform Backend Issues**:
   - Verify the S3 bucket and DynamoDB table exist
   - Check that the IAM role has access to these resources

3. **Failed Security Scans**:
   - Review the security scan reports in the GitHub Actions logs
   - Address the identified issues in your code
   - For false positives, consider adding appropriate exceptions

## Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS IAM OIDC Documentation](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html)