# devsecops-pipeline

A DevSecOps study project exploring CI/CD automation, infrastructure-as-code, and AWS provisioning. Originally developed as a learning vehicle using a minimal Go service (`shadow-api`), with the intended application being the logbook project (a hypertrophy/training tracking AI API). Inspired by Dorian Yates' training philosophy—just as the shadow represents the true form, this pipeline's infrastructure patterns are meant to scale with the real application.

## Study Status

This repository is archived and represents one focused study session. It has been polished and documented for portfolio purposes. The pipeline demonstrates core DevSecOps principles and was the foundation for understanding AWS infrastructure automation and CI/CD security gates.

## Implementation

The pipeline validates application code, validates infrastructure code, scans both for security issues, provisions ephemeral AWS resources (ECR repository), builds and pushes container artifacts, simulates QA execution, and tears the environment down automatically. 

Current scope focuses on ECR provisioning and image management. It does not include long-running compute targets (ECS, EC2, EKS), as the goal was to learn the security gate patterns and ephemeral resource lifecycle.

## Learning Outcomes

This study focused on:

- **AWS Infrastructure**: ECR repositories, lifecycle policies, and cost-conscious ephemeral provisioning
- **Terraform IaC**: Modular infrastructure code, validation, formatting, and state management
- **Security Scanning**: Trivy for container vulnerabilities and tfsec for infrastructure misconfigurations
- **CI/CD Automation**: GitHub Actions workflows, conditional execution, and guaranteed cleanup with `if: always()`
- **DevSecOps Principles**: Shift-left security, multi-gate validation, fail-fast patterns, and cost-aware resource cleanup

## Architecture

```text
GitHub Push
    |
    v
GitHub Actions: qa-pipeline.yml
    |
    +--> build-and-test
    |      - go test ./...
    |      - docker build
    |      - Trivy image scan
    |
    +--> terraform-check
    |      - terraform init
    |      - terraform fmt -check
    |      - terraform validate
    |      - tfsec scan
    |
    +--> ephemeral-qa-teardown
           - configure AWS credentials from GitHub Secrets
           - terraform apply
           - capture ECR output
           - login to ECR
           - build, tag, and push image
           - simulate QA execution
           - terraform destroy with if: always()
```

## Components

### Application

- [`docker/main.go`](docker/main.go): minimal Go HTTP service with `GET /health`.
- [`docker/Dockerfile`](docker/Dockerfile): multi-stage build using `golang:1.22-alpine` for compilation and `scratch` for the runtime image.
- [`docker/go.mod`](docker/go.mod): isolated Go module for the service.

### Infrastructure

- [`terraform/main.tf`](terraform/main.tf): AWS provider and `aws_ecr_repository`.
- [`terraform/variables.tf`](terraform/variables.tf): variable-driven region and repository name.
- [`terraform/outputs.tf`](terraform/outputs.tf): ECR ARN, name, and repository URL for downstream pipeline use.

### Automation

- [`.github/workflows/qa-pipeline.yml`](.github/workflows/qa-pipeline.yml): CI/CD workflow that enforces validation, security scanning, ephemeral provisioning, image push, and teardown.

## Security Gates

The workflow blocks progress in three distinct layers.

### 1. Application Validation

The `build-and-test` job fails fast on:

- Go test failures via `go test ./...`
- Docker build failures

### 2. Container Security

The same job runs Trivy against the locally built image and fails with exit code `1` if any `HIGH` or `CRITICAL` vulnerability is found.

This prevents known severe image issues from progressing to the AWS push stage.

### 3. Infrastructure Security

The `terraform-check` job enforces:

- `terraform fmt -check`
- `terraform validate`
- `tfsec` static analysis against the Terraform directory

This blocks malformed or insecure IaC before any `terraform apply` can run.

## Ephemeral Teardown Logic

The `ephemeral-qa-teardown` job is intentionally structured around cleanup guarantees.

- It depends on `build-and-test` and `terraform-check` via `needs`, so provisioning only starts after both gates pass.
- It authenticates to AWS using GitHub Secrets: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and `AWS_REGION`.
- It runs `terraform apply -auto-approve` to create the ECR repository.
- It pushes the built image to the freshly provisioned ECR repository.
- It simulates the QA execution step against the pushed artifact.
- It always runs `terraform destroy -auto-approve` with `if: always()`.

That final condition is the cost-control mechanism. Even if the simulated QA step fails, GitHub Actions still executes the destroy step, which prevents orphaned infrastructure from remaining in AWS.

At the Terraform layer, the ECR repository is also configured with `force_delete = true`, which allows destroy to remove the repository and its images without manual cleanup.

## Operational Principles

This repository is intentionally opinionated around:

- KISS: minimal moving parts and explicit workflow steps
- DRY: region and repository naming live in Terraform variables, not duplicated in resource blocks
- YAGNI: only ECR is provisioned because that is the current requirement
- Idempotency: Terraform and CI steps are designed to be rerun safely with the same intent
- Fail Fast: tests, validation, and security scanners stop the pipeline on first critical issue

The full doctrine is documented in [`AGENT_RULES.md`](AGENT_RULES.md).

## Repository Layout

```text
.
|-- .github/
|   `-- workflows/
|       `-- qa-pipeline.yml
|-- docker/
|   |-- Dockerfile
|   |-- go.mod
|   `-- main.go
|-- terraform/
|   |-- main.tf
|   |-- outputs.tf
|   `-- variables.tf
|-- AGENT_RULES.md
`-- README.md
```

## Required GitHub Secrets

To run the AWS portion of the workflow, the repository must define:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`

## Notes

The workflow is configured to trigger on pushes to the `main` branch. To activate the automated CI/CD pipeline, ensure the GitHub Secrets are configured in the repository settings.
