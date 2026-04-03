# Automated QA Pipeline via Infrastructure-as-Code

This repository is the foundation for an end-to-end DevOps and QA project built around the `Orderly` backend.

## Project Goal

Create a simple, reliable, and fully automated delivery pipeline that:

1. Provisions a temporary AWS environment with Terraform.
2. Containerizes the `Orderly` backend with Docker.
3. Deploys the container through CI/CD automation.
4. Runs a strict suite of automated QA tests against the deployed app.
5. Tears the infrastructure down after validation is complete.

## Core Principles

- Ephemeral environments to keep costs low and reduce drift.
- KISS-first design to keep the pipeline understandable and maintainable.
- Strong automation to prove repeatable deployment and QA execution.
- Clear separation of concerns across infrastructure, containerization, and workflows.

## Repository Structure

```text
.
|-- .github/
|   `-- workflows/
|-- docker/
|-- terraform/
`-- README.md
```

## Directory Purpose

- `terraform/`: AWS infrastructure definitions for short-lived environments.
- `docker/`: Containerization assets for the `Orderly` backend.
- `.github/workflows/`: GitHub Actions workflows for provisioning, deployment, testing, and teardown.

## Planned Workflow

The pipeline will provision infrastructure on demand, deploy the containerized application, execute automated QA checks, and destroy the environment once validation is complete.
