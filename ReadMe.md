# AWS ECS Deployment using Terraform - Ruby on Rails Application

## Overview

This project demonstrates deploying a Dockerized Ruby on Rails application on AWS using Infrastructure as Code (Terraform).

The application is deployed using AWS ECS Fargate with an Application Load Balancer, Amazon RDS PostgreSQL, Amazon S3, and Amazon ECR.

The infrastructure follows AWS best practices:

* Load Balancer hosted in public subnets
* ECS workloads hosted in private application subnets
* Database hosted in private database subnets
* IAM Role based access for S3 (No AWS Access Key / Secret Key)
* Docker image build and deployment through GitHub Actions

---

# Architecture

The deployment architecture contains the following AWS services:

## CI/CD Flow

```
Developer
    |
    |
GitHub Repository
    |
    |
GitHub Actions
    |
    |
Docker Build
    |
    |
Amazon ECR
    |
    |
ECS Task Definition
    |
    |
ECS Service
```

---

## AWS Infrastructure

```
                         Internet
                            |
                            |
                 Application Load Balancer
                    (Public Subnets)
                            |
              --------------------------------
              |                              |
          ECS Task 1                     ECS Task 2
        (Private Subnet)              (Private Subnet)
              |
              |
       ------------------
       |                |
    RDS PostgreSQL     Amazon S3
    (Private DB)     (Object Storage)

              |
              |
        CloudWatch Logs
```

---

# AWS Services Used

| Service                   | Purpose                                      |
| ------------------------- | -------------------------------------------- |
| Amazon VPC                | Network isolation                            |
| Public Subnets            | ALB hosting                                  |
| Private Subnets           | ECS application hosting                      |
| Private DB Subnets        | RDS database hosting                         |
| Internet Gateway          | Public internet access                       |
| NAT Gateway               | Outbound internet access from private subnet |
| Application Load Balancer | Traffic distribution                         |
| ECS Fargate               | Container orchestration                      |
| ECR                       | Docker image repository                      |
| RDS PostgreSQL            | Application database                         |
| S3                        | Application object storage                   |
| IAM Roles                 | Secure AWS service access                    |
| CloudWatch Logs           | Container logging                            |

---

# Application Details

## Application Stack

| Component          | Version       |
| ------------------ | ------------- |
| Ruby               | 3.2.2         |
| Rails              | 7.0.5         |
| Database           | PostgreSQL 13 |
| Container Runtime  | Docker        |
| Container Platform | ECS Fargate   |

---

# Repository Structure

```
.
├── docker
│   ├── app
│   │   ├── Dockerfile
│   │   └── entrypoint.sh
│   |
│   └── nginx
│       ├── Dockerfile
│       └── default.conf
│
├── infrastructure
│   |
│   ├── modules
│   │   ├── vpc
│   │   ├── ecs
│   │   ├── ecs-task
│   │   ├── alb
│   │   ├── rds
│   │   ├── s3
│   │   ├── ecr
│   │   └── security-group
│   |
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── README.md
│
└── .github
    └── workflows
        └── build-push-ecr.yml
```

---

# Prerequisites

Before deployment, install:

* AWS CLI
* Terraform
* Docker
* Git

Configure AWS credentials:

```
aws configure
```

Required permissions:

* VPC
* ECS
* ECR
* RDS
* S3
* IAM
* ALB
* CloudWatch

---

# Docker Image Build Process

GitHub Actions automatically builds and pushes the Docker image.

Workflow:

```
Git Push
   |
   |
GitHub Actions Trigger
   |
   |
Docker Build
   |
   |
Login to Amazon ECR
   |
   |
Push Image to ECR
```

ECR Repository:

```
ror-app-dev-rails
```

---

# Terraform Deployment

Navigate to infrastructure folder:

```
cd infrastructure
```

Initialize Terraform:

```
terraform init
```

Validate configuration:

```
terraform validate
```

Review changes:

```
terraform plan
```

Deploy infrastructure:

```
terraform apply
```

---

# Terraform Destroy

To remove all AWS resources:

```
terraform destroy
```

---

# Environment Variables

The ECS task receives application configuration through environment variables.

## Rails Container Variables

| Variable       | Description                        |
| -------------- | ---------------------------------- |
| RDS_DB_NAME    | PostgreSQL database name           |
| RDS_USERNAME   | Database username                  |
| RDS_PASSWORD   | Database password                  |
| RDS_HOSTNAME   | RDS endpoint                       |
| RDS_PORT       | PostgreSQL port                    |
| S3_BUCKET_NAME | S3 bucket name                     |
| S3_REGION_NAME | AWS region                         |
| LB_ENDPOINT    | Application Load Balancer endpoint |

---

# Security Implementation

## S3 Authentication

The application accesses S3 using ECS Task IAM Role.

Implementation:

* ECS Task Role created using Terraform
* Least privilege S3 policy attached
* Application does not use:

  * AWS Access Key
  * AWS Secret Key

AWS SDK automatically retrieves temporary credentials from ECS Task Role.

---

# Database Configuration

Amazon RDS PostgreSQL is deployed in private database subnets.

Connection details are provided to ECS using environment variables:

```
RDS_HOSTNAME
RDS_DB_NAME
RDS_USERNAME
RDS_PASSWORD
RDS_PORT
```

---

# Networking

## Public Subnet

Contains:

* Application Load Balancer

Internet access:

```
Internet
   |
Internet Gateway
   |
Public Route Table
```

---

## Private Application Subnet

Contains:

* ECS Fargate Tasks

Outbound internet access:

```
Private Subnet
      |
 NAT Gateway
      |
Internet Gateway
```

---

## Private Database Subnet

Contains:

* PostgreSQL RDS Instance

Access allowed only from ECS Security Group.

---

# Access Application

After deployment:

1. Open AWS Console
2. Navigate to EC2 → Load Balancers
3. Copy ALB DNS name

Example:

```
http://<ALB-DNS-NAME>
```

---

# Monitoring

Application logs are sent to:

```
Amazon CloudWatch Logs
```

Monitoring includes:

* ECS task logs
* Application errors
* Container status

---

# Deployment Screenshots

Include:

* GitHub Actions successful build
* ECR image
* ECS Cluster
* ECS Service
* Running Tasks
* ALB Target Group Healthy
* RDS Instance
* S3 Bucket
* Application running through ALB

---

# Conclusion

This implementation provides a scalable and secure deployment of a Ruby on Rails application using AWS ECS Fargate, Terraform, Docker, and GitHub Actions following Infrastructure as Code and DevOps best practices.
