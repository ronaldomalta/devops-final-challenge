variable "aws_region" {
  description = "Região da AWS emulada no LocalStack"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto para identificação e tags"
  type        = string
  default     = "startup-moderna"
}

variable "environment" {
  description = "Ambiente de implantação"
  type        = string
  default     = "production"
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t2.micro"
}

variable "api_docker_image" {
  description = "Imagem pública da API Node.js no Docker Hub"
  type        = string
  default     = "alancezar/api-node:latest"
}

variable "frontend_docker_image" {
  description = "Imagem pública do Frontend React no Docker Hub"
  type        = string
  default     = "alancezar/frontend-react:latest"
}

variable "api_port" {
  description = "Porta exposta pela API Node.js"
  type        = number
  default     = 3000
}

variable "frontend_port" {
  description = "Porta de acesso ao Frontend React"
  type        = number
  default     = 80
}

variable "assets_bucket_name" {
  description = "Nome do bucket S3 para assets da aplicação"
  type        = string
  default     = "startup-app-assets-bucket"
}


