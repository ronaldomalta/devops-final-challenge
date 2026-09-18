#  Modernização de Infraestrutura e Observabilidade - Desafio DevOps

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![LocalStack](https://img.shields.io/badge/LocalStack-000000?style=for-the-badge&logo=localstack&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)
![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)
![React](https://img.shields.io/badge/React-61DAFB?style=for-the-badge&logo=react&logoColor=black)

## 📌 Visão Geral do Projeto

Este repositório contém a solução automatizada para a modernização da infraestrutura de uma startup em fase de hipercrescimento. Anteriormente, a empresa enfrentava gargalos decorrentes de **deploys manuais**, **falta de padronização nos ambientes** e **ausência de métricas em tempo real** sobre a saúde das aplicações.

Com esta solução, entregamos:
1. **Padronização e Containerização** de aplicações web (Frontend em React e Backend em Node.js).
2. **Infraestrutura como Código (IaC)** utilizando Terraform simulado via LocalStack (AWS).
3. **Pipeline Contínua de CI/CD** via GitHub Actions publicando imagens automaticamente no Docker Hub.
4. **Stack Completa de Observabilidade** com Prometheus e Grafana para monitoramento em tempo real.

---

## 🛠️ Tecnologias e Ferramentas

- **Controle de Versão:** Git & GitHub
- **Containerização:** Docker & Docker Hub
- **CI/CD:** GitHub Actions
- **Infraestrutura como Código (IaC):** Terraform & LocalStack (Simulação AWS)
- **Backend:** Node.js (com métricas expostas para Prometheus)
- **Frontend:** React
- **Observabilidade:** Prometheus & Grafana

---

## 📂 Estrutura do Repositório

```text
.
├── .github/
│   └── workflows/
│       └── deploy-pipeline.yml   # Pipeline CI/CD para Build e Push de Imagens
├── backend/                      # API Node.js com instrumentação Prometheus
│   ├── Dockerfile
│   ├── index.js
│   └── package.json
├── frontend/                     # Aplicação React
│   ├── Dockerfile
│   └── src/
├── terraform/                    # Configurações de Infraestrutura como Código
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── monitoring/                   # Configurações do Prometheus e Grafana
│   ├── prometheus/
│   │   └── prometheus.yml
│   └── grafana/
│       └── dashboards/
├── docker-compose.yml            # Orquestração local para ambiente de desenvolvimento/testes
└── README.md
```

---

## 🚀 Como Executar o Projeto Localmente

### Pré-requisitos
Certifique-se de ter instalado em sua máquina:
- [Docker](https://www.docker.com/) e [Docker Compose](https://docs.docker.com/compose/)
- [Terraform](https://www.terraform.io/) (v1.0+)
- [LocalStack CLI](https://docs.localstack.cloud/getting-started/installation/) ou Docker
- [Git](https://git-scm.com/)

---

### 1️⃣ Clonar o Repositório

```bash
git clone https://github.com/seu-usuario/nome-do-repositorio.git
cd nome-do-repositorio
```

---

### 2️⃣ Rodar a Aplicação e Observabilidade via Docker Compose

Para subir rapidamente o ambiente local contendo Frontend, Backend, Prometheus e Grafana:

```bash
docker-compose up -d --build
```

**Endereços de Acesso Local:**
- **Frontend (React):** `http://localhost:3000`
- **Backend API (Node.js):** `http://localhost:5000`
- **Métricas Prometheus (Endpoint API):** `http://localhost:5000/metrics`
- **Prometheus UI:** `http://localhost:9090`
- **Grafana Dashboard:** `http://localhost:3001` *(Login padrão: admin / admin)*

---

### 3️⃣ Provisionar Infraestrutura com Terraform + LocalStack

1. **Inicie o LocalStack** (se não estiver rodando no docker-compose):
   ```bash
   localstack start -d
   ```

2. **Navegue até a pasta do Terraform e inicialize:**
   ```bash
   cd terraform
   terraform init
   ```

3. **Valide e aplique o plano no LocalStack:**
   ```bash
   terraform plan
   terraform apply -auto-approve
   ```

---

## 🔄 Pipeline CI/CD (GitHub Actions)

A esteira de integração e entrega contínua é disparada a cada **push na branch `main`**.

### Etapas da Pipeline (`.github/workflows/deploy-pipeline.yml`):
1. **Checkout:** Baixa o código mais recente do repositório.
2. **Docker Login:** Autentica com as credenciais salvas nos *Secrets* do GitHub (`DOCKER_HUB_USERNAME` e `DOCKER_HUB_TOKEN`).
3. **Build & Push Frontend:** Constrói a imagem Docker do React e envia para o Docker Hub.
4. **Build & Push Backend:** Constrói a imagem Docker da API Node.js e envia para o Docker Hub.

---

## 📊 Observabilidade e Monitoramento

A API Node.js expõe um endpoint `/metrics` utilizando a biblioteca `prom-client`. O Prometheus faz a raspagem (*scraping*) periódica desses dados.

### Métricas Coletadas:
- **Taxa de Requisições por Segundo (RPS)**
- **Tempo de Resposta / Latência de Requisições HTTP**
- **Uso de CPU e Memória da Aplicação**
- **Códigos de Status HTTP (2xx, 4xx, 5xx)**

### Dashboard no Grafana:
Ao acessar o Grafana em `http://localhost:3001`:
1. O data source do **Prometheus** já está configurado automaticamente.
2. O dashboard pré-configurado pode ser encontrado na aba *Dashboards*, permitindo a visualização dos gráficos em tempo real.

---

## 🎤 Apresentação Executiva (Pitch de 5 Minutos)

Para a simulação com a diretoria, a estrutura do Pitch foi organizada no seguinte roteiro:

| Tempo | Tópico | Conteúdo Abordado |
| :--- | :--- | :--- |
| **00:00 - 01:00** | **O Problema e a Solução** | Apresentação das dores anteriores (deploys manuais, imprevistos, falta de visibilidade) e o valor do DevOps. |
| **01:00 - 02:30** | **Arquitetura & Ferramentas** | Explicação técnica e de negócio da stack escolhida (Docker, Terraform, LocalStack, GitHub Actions, Prometheus/Grafana). |
| **02:30 - 04:30** | **Demonstração Prática** | *Live Demo*: Alteração no código -> Trigger da Pipeline no GitHub Actions -> Imagem no Docker Hub -> Infra via Terraform/LocalStack -> Métricas no Grafana. |
| **04:30 - 05:00** | **Encerramento** | Conclusão ressaltando a confiabilidade, escalabilidade e segurança do novo ambiente entregue. |

---

## 👥 Equipe do Projeto

- **Edson Vinicius** - *DevSecOps / [GitHub](https://github.com/ViniciusS4ntos)*
- **Alan Cezar** - *DevSecOps / [GitHub](https://github.com/alancezarholanda)*
- **Ronaldo Malta** - *DevSecOps / [GitHub](https://github.com/ronaldomalta)*

---

## 📜 Licença

Este projeto foi desenvolvido para fins educacionais como parte do **Desafio Prático Final de DevOps**.