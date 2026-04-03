variable "aws_region" {
  description = "AWS region for provisioning the ephemeral QA infrastructure."
  type        = string
  default     = "us-east-1"
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository that stores the shadow-api image."
  type        = string
  default     = "shadow-api"
}
