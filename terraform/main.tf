# ==============================================================================
# REDE: VPC, SUBNET E ROTEAMENTO
# ==============================================================================

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name        = "${var.project_name}-public-subnet"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-igw"
    Environment = var.environment
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.project_name}-public-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# ==============================================================================
# SEGURANÇA: SECURITY GROUP (FRONTEND, API E MONITORAMENTO)
# ==============================================================================

resource "aws_security_group" "app_sg" {
  name        = "${var.project_name}-sg"
  description = "Regras de entrada e saida para a aplicacao e monitoramento"
  vpc_id      = aws_vpc.main.id

  # Frontend (React)
  ingress {
    description = "Frontend React HTTP"
    from_port   = var.frontend_port
    to_port     = var.frontend_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Backend (API Node.js + /metrics do Prometheus)
  ingress {
    description = "API Node.js e endpoint de metricas"
    from_port   = var.api_port
    to_port     = var.api_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Observabilidade (Prometheus)
  ingress {
    description = "Prometheus Server"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Observabilidade (Grafana)
  ingress {
    description = "Grafana Dashboard"
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Acesso SSH para manutencao
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Saida livre para pull de imagens no Docker Hub e pacotes do sistema
  egress {
    description = "Trafego de saida liberado"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-sg"
    Environment = var.environment
  }
}

# ==============================================================================
# ARMAZENAMENTO: BUCKET S3
# ==============================================================================

resource "aws_s3_bucket" "app_assets" {
  bucket = var.assets_bucket_name

  tags = {
    Name        = var.assets_bucket_name
    Environment = var.environment
  }
}

# ==============================================================================
# COMPUTAÇÃO: INSTÂNCIA EC2 COM DEPLOY AUTOMÁTICO VIA DOCKER
# ==============================================================================

resource "aws_instance" "app_server" {
  ami                    = "ami-df5de72f" # AMI padrao do LocalStack para Linux
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              set -e

              # 1. Atualizar pacotes e instalar Docker
              apt-get update -y
              apt-get install -y docker.io docker-compose

              systemctl start docker
              systemctl enable docker

              # 2. Criar rede para comunicacao entre containers
              docker network create app-network || true

              # 3. Pull das imagens publicadas pelo GitHub Actions no Docker Hub
              docker pull ${var.api_docker_image}
              docker pull ${var.frontend_docker_image}

              # 4. Execucao do container da API Node.js (com metricas expostas em /metrics)
              docker run -d \
                --name backend-api \
                --restart always \
                --network app-network \
                -p ${var.api_port}:${var.api_port} \
                ${var.api_docker_image}

              # 5. Execucao do container do Frontend React
              docker run -d \
                --name frontend-app \
                --restart always \
                --network app-network \
                -p ${var.frontend_port}:80 \
                ${var.frontend_docker_image}
              EOF

  tags = {
    Name        = "${var.project_name}-ec2-server"
    Environment = var.environment
  }
}

