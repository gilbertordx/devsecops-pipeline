output "ecr_repository_arn" {
  description = "ARN of the ECR repository."
  value       = aws_ecr_repository.shadow_api.arn
}

output "ecr_repository_name" {
  description = "Name of the ECR repository."
  value       = aws_ecr_repository.shadow_api.name
}

output "ecr_repository_url" {
  description = "Repository URL used for image pushes."
  value       = aws_ecr_repository.shadow_api.repository_url
}
