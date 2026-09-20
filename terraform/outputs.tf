output "ec2_instance_id" {
  description = "ID da instancia EC2 provisionada no LocalStack"
  value       = aws_instance.app_server.id
}

output "ec2_public_ip" {
  description = "IP publico da instancia EC2"
  value       = aws_instance.app_server.public_ip
}

output "frontend_url" {
  description = "URL de acesso ao Frontend React"
  value       = "http://${aws_instance.app_server.public_ip}:${var.frontend_port}"
}

output "api_url" {
  description = "URL de acesso a API Node.js"
  value       = "http://${aws_instance.app_server.public_ip}:${var.api_port}"
}

output "api_metrics_url" {
  description = "Endpoint de metricas Prometheus na API"
  value       = "http://${aws_instance.app_server.public_ip}:${var.api_port}/metrics"
}

output "s3_bucket_name" {
  description = "Nome do bucket S3 provisionado"
  value       = aws_s3_bucket.app_assets.bucket
}

output "vpc_id" {
  description = "ID da VPC criada"
  value       = aws_vpc.main.id
}

