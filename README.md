# Fullstack CI/CD Pipeline — AWS + Jenkins + ECS

A fully automated CI/CD pipeline that builds, pushes, and deploys a containerized fullstack application (React frontend + Node.js backend) to AWS ECS Fargate using Jenkins.

---

## Live URLs

- **Frontend:** http://frontend-alb-1462025716.us-east-2.elb.amazonaws.com
- **Jenkins:** http://18.117.92.68:8080

---

## Project Overview

This project demonstrates a complete DevOps workflow:

1. Code is pushed to GitHub
2. Jenkins pulls the repo and builds Docker images for both frontend and backend
3. Images are pushed to Amazon ECR
4. ECS services are updated to deploy the new images automatically

---

## AWS Resources

### Jenkins Server
- **EC2 Instance (t3.small):** Hosts the Jenkins CI/CD server running on Ubuntu 24.04 in the `us-east-2` region
- **Security Group (jenkins-sg):** Allows inbound traffic on port 8080 (Jenkins UI) and port 22 (SSH access)
- **IAM Role (jenkins-role):** Attached to the EC2 instance with the following permissions:
  - `AmazonEC2ContainerRegistryFullAccess` — push/pull Docker images to/from ECR
  - `AmazonECS_FullAccess` — trigger ECS service updates
  - `AmazonS3ReadOnlyAccess` — read access to S3

### Networking
- **VPC** with public and private subnets across two availability zones
- **Internet Gateway (IGW)** for public internet access
- **Route Tables** configured for public subnet routing

### Container Infrastructure
- **ECR Repositories:** `fullstack-frontend` and `fullstack-backend` for storing Docker images
- **ECS Cluster (fullstack-cluster):** Fargate-based cluster running both services
- **ECS Task Definitions:** Separate task definitions for frontend (port 3000) and backend (port 8080)
- **ECS Services:** `frontend-service` and `backend-service` with desired count of 1
- **Application Load Balancer (ALB):** Routes public HTTP traffic to the frontend ECS service

---

## Repository Structure

```
techpathway-2/
├── frontend/               # React frontend app
│   ├── Dockerfile
│   └── src/
├── backend/                # Node.js backend app
│   ├── Dockerfile
│   └── index.js
├── infra/                  # Terraform infrastructure
│   ├── provider.tf
│   ├── networking.tf
│   ├── security.tf
│   ├── jenkins.tf
│   ├── ecs.tf
│   ├── ecr.tf
│   ├── alb.tf
│   ├── iam.tf
│   └── outputs.tf
└── Jenkinsfile             # CI/CD pipeline definition
```

---

## CI/CD Pipeline

The `Jenkinsfile` defines a pipeline with the following stages:

| Stage | Description |
|-------|-------------|
| Checkout | Pulls latest code from GitHub main branch |
| Build Docker Images | Builds frontend and backend Docker images |
| Login to ECR | Authenticates Docker with Amazon ECR |
| Push Images to ECR | Tags and pushes both images to ECR |
| Deploy to ECS | Triggers force-new-deployment on both ECS services |

### Running the Pipeline

1. Log into Jenkins at `http://18.117.92.68:8080`
2. Open the `fullstack-pipeline` job
3. Click **Build Now**
4. Monitor progress under **Console Output**

---

## Terraform Infrastructure

All AWS infrastructure is defined as code using Terraform.

### Prerequisites
- Terraform installed
- AWS CLI configured with appropriate credentials
- AWS region: `us-east-2`

### Deploy Infrastructure

```bash
cd infra/
terraform init
terraform plan
terraform apply
```

### Destroy Infrastructure

```bash
terraform destroy
```

---

## Docker Setup

### Frontend Dockerfile
Multi-stage build — compiles React app, serves with `serve` on port 3000.

### Backend Dockerfile
Node.js app running on port 8080.

### Build Locally

```bash
# Frontend
docker build -t fullstack-frontend ./frontend

# Backend
docker build -t fullstack-backend ./backend
```

---

## Environment Variables

The Jenkins pipeline uses the following environment variables defined in the `Jenkinsfile`:

| Variable | Value |
|----------|-------|
| AWS_REGION | us-east-2 |
| AWS_ACCOUNT_ID | 208744928440 |
| FRONTEND_REPO | fullstack-frontend |
| BACKEND_REPO | fullstack-backend |
| ECS_CLUSTER | fullstack-cluster |
| FRONTEND_SERVICE | frontend-service |
| BACKEND_SERVICE | backend-service |

---

## Setup Instructions

### 1. Clone the repo
```bash
git clone https://github.com/JadenSal/techpathway-2.git
cd techpathway-2
```

### 2. Deploy infrastructure
```bash
cd infra/
terraform init
terraform apply
```

### 3. Configure Jenkins
- Navigate to `http://<JENKINS_IP>:8080`
- Install plugins: Docker Pipeline, Amazon ECR, AWS Credentials
- Create a new Pipeline job pointing to this GitHub repo
- Set branch to `main` and script path to `Jenkinsfile`

### 4. Run the pipeline
- Click **Build Now** in Jenkins
- Pipeline will build, push, and deploy both services automatically
## How to Run the App Locally (for Testing)

### Backend
```bash
cd backend
npm ci
npm start
```
Runs on: `http://localhost:8080`

### Frontend
```bash
cd frontend
npm ci
npm start
```
Runs on: `http://localhost:3000`
