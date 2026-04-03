# AGENT_RULES

This repository follows a strict operational doctrine for infrastructure, delivery automation, and quality assurance work.

## Mandatory Engineering Principles

### KISS

Keep every solution as simple as possible. Prefer the smallest design that clearly solves the current requirement without unnecessary layers, services, or abstractions.

### SOLID

Apply SOLID thinking to application code, pipeline logic, and infrastructure modules:

- Single Responsibility: each module, workflow, or script should do one job well.
- Open/Closed: extend behavior with configuration or composition before rewriting working components.
- Liskov Substitution: interchangeable modules must behave predictably.
- Interface Segregation: keep interfaces focused and small.
- Dependency Inversion: depend on stable abstractions and explicit inputs, not hard-coded implementation details.

### DRY

Avoid duplication across Terraform, Docker assets, CI workflows, and test automation. Shared behavior should live in one clear place and be reused intentionally.

## Operational Doctrine

### YAGNI

Do not build for hypothetical future requirements. Implement only what is required for the current pipeline, environment, and QA flow.

### Idempotency

Infrastructure and automation must be safe to run repeatedly. A Terraform apply, deployment job, or validation step should produce the same intended outcome no matter how many times it is executed under the same inputs.

### Fail Fast

Failures must surface immediately and clearly. Builds, deployments, and QA checks should stop on first critical error rather than continuing with partial or misleading results.

## Working Standard

- Prefer short-lived environments over long-lived mutable environments.
- Make automation explicit, observable, and repeatable.
- Keep repository structure clear enough that infrastructure, containerization, and CI/CD concerns remain easy to understand.
