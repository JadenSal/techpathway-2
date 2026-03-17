output "frontend_url" {

  description = "Frontend URL"

  value       = aws_lb.frontend.dns_name

}

output "backend_url" {

  description = "Backend URL"

  value       = aws_lb.backend.dns_name

}

output "frontend_ecr_url" {

  description = "Frontend ECR URL"

  value       = aws_ecr_repository.frontend.repository_url

}

output "backend_ecr_url" {

  description = "Backend ECR URL"

  value       = aws_ecr_repository.backend.repository_url

}

output "jenkins_url" {
  description = "Jenkins URL"
  value       = "http://${aws_instance.jenkins.public_ip}:8080"
}
