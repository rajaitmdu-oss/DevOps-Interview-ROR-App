# Deployment Guide

## Project Overview

This project deploys a Dockerized Ruby on Rails application on AWS using Terraform and Amazon ECS Fargate. The infrastructure follows AWS best practices by placing the Application Load Balancer in public subnets while hosting ECS tasks and Amazon RDS in private subnets.

The Docker image is automatically built and pushed to Amazon ECR using GitHub Actions. ECS Fargate pulls the latest image from ECR and serves the application through an Application Load Balancer.

---

# Solution Architecture

The deployment consists of the following AWS components:

- Amazon VPC
- Public Subnets
- Private Application Subnets
- Private Database Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- Security Groups
- Amazon ECS Cluster
- Amazon ECS Service
- ECS Task Definition
- Amazon ECR
- Amazon RDS PostgreSQL
- Amazon S3
- Application Load Balancer
- IAM Roles
- CloudWatch Logs

Refer to **architecture-diagram.png** for the complete architecture.

---

# Deployment Workflow

The deployment process follows these steps:

Developer

↓

Push Code to GitHub

↓

GitHub Actions

↓

Docker Image Build

↓

Push Image to Amazon ECR

↓

Terraform Deployment

↓

Amazon ECS Fargate

↓

Application Load Balancer

↓

End Users

---

# Infrastructure Provisioning

Terraform provisions the following infrastructure.

## Networking

- Amazon VPC
- Internet Gateway
- NAT Gateway
- Public Route Table
- Private Route Table
- Public Subnets
- Private Application Subnets
- Private Database Subnets

---

## Compute

- Amazon ECS Cluster
- ECS Task Definition
- ECS Service (Fargate)

---

## Database

- Amazon RDS PostgreSQL

Database runs inside private database subnets and is accessible only from ECS Security Group.

---

## Storage

Amazon S3 bucket is provisioned for application storage.

The application accesses S3 using ECS Task IAM Role instead of AWS Access Keys.

---

## Container Registry

Amazon ECR stores the Docker image.

GitHub Actions automatically pushes the latest image after every commit to the configured branch.

---

## Load Balancer

Application Load Balancer

- Internet-facing
- Hosted in public subnets
- Routes traffic to ECS tasks
- Performs health checks

---

# CI/CD Pipeline

The GitHub Actions workflow performs the following steps:

1. Checkout source code
2. Configure AWS credentials
3. Login to Amazon ECR
4. Build Docker image
5. Tag Docker image
6. Push Docker image to Amazon ECR

---

# Environment Variables

The Rails container receives the following environment variables through the ECS Task Definition.

| Variable | Description |
|----------|-------------|
| RDS_DB_NAME | PostgreSQL database name |
| RDS_USERNAME | Database username |
| RDS_PASSWORD | Database password |
| RDS_HOSTNAME | Amazon RDS endpoint |
| RDS_PORT | PostgreSQL port |
| S3_BUCKET_NAME | Amazon S3 bucket |
| S3_REGION_NAME | AWS Region |
| LB_ENDPOINT | Application Load Balancer DNS |

---

# IAM Authentication

Amazon S3 access is provided using ECS Task IAM Role.

No AWS Access Key ID or Secret Access Key is stored inside the application.

Permissions granted:

- s3:GetObject
- s3:PutObject
- s3:DeleteObject
- s3:ListBucket

This follows AWS security best practices.

---

# Deployment Steps

Clone Repository

```bash
git clone <repository-url>
cd DevOps-Interview-ROR-App
```

Initialize Terraform

```bash
cd infrastructure

terraform init
```

Validate

```bash
terraform validate
```

Review Plan

```bash
terraform plan
```

Deploy Infrastructure

```bash
terraform apply
```

---

# Verify Deployment

After deployment verify:

- ECS Cluster is Active
- ECS Service is Running
- ECS Tasks are Healthy
- Target Group Health Checks are Healthy
- Application Load Balancer is Active
- Amazon RDS is Available
- Amazon S3 Bucket is Created
- Docker Image exists in Amazon ECR

Open the ALB DNS name in a browser to verify the application.

---

# Monitoring

Application logs are available in:

Amazon CloudWatch Logs

Monitor:

- ECS Task Logs
- Container Startup Logs
- Application Errors

---

# Security Best Practices

The deployment follows these security practices:

- ECS tasks deployed in private subnets
- Database deployed in private subnets
- Internet-facing Application Load Balancer only
- IAM Role authentication for Amazon S3
- No hardcoded AWS credentials
- Security Groups restrict inbound access
- Private networking between ECS and RDS

---

# Troubleshooting

## ECS Task Not Starting

- Check CloudWatch Logs
- Verify Task Definition
- Verify Environment Variables

---

## Docker Image Pull Failure

- Verify Amazon ECR repository
- Verify ECS Execution Role permissions

---

## Database Connection Failure

- Verify RDS endpoint
- Verify Security Groups
- Verify database credentials

---

## ALB Health Check Failure

- Verify ECS Service
- Verify Target Group
- Verify container port
- Verify application is listening on port 3000

---

# Cleanup

To remove all AWS resources:

```bash
terraform destroy
```

---

# Conclusion

This solution demonstrates a complete Infrastructure as Code deployment of a Ruby on Rails application using Terraform, Amazon ECS Fargate, Amazon ECR, Amazon RDS PostgreSQL, Amazon S3, GitHub Actions, and Application Load Balancer while following AWS security and DevOps best practices.