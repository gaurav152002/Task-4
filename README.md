# Task 4 – Deploy Strapi on AWS using Terraform

## Objective
Design and deploy a secure AWS infrastructure using **Terraform** that runs a **Strapi application** on a **private EC2 instance**, accessible through a **public Application Load Balancer**.  
The setup uses **public and private subnets**, **NAT Gateway**, **security groups**, **Docker**, and **environment-based configuration**.

---

## Architecture Overview

### Components
- VPC with custom CIDR
- Two **public subnets** (for ALB, different AZs)
- One **private subnet** (for EC2)
- Internet Gateway for public subnets
- NAT Gateway for outbound access from private subnet
- Private EC2 instance running Docker & Strapi
- Application Load Balancer (ALB)
- Security Groups for access control
- Terraform modules for clean structure

### Traffic Flow
User → ALB (Public) → EC2 (Private) → Docker → Strapi


## Repository Structure

Terraform_files/
├── provider.tf
├── variables.tf
├── main.tf
├── outputs.tf
│
├── environments/
│ └── dev.tfvars
│
├── modules/
│ ├── vpc/
│ │ ├── main.tf
│ │ ├── variables.tf
│ │ └── outputs.tf
│ │
│ ├── ec2/
│ │ ├── main.tf
│ │ ├── variables.tf
│ │ ├── outputs.tf
│ │ └── user_data.sh
│ │
│ └── alb/
│ ├── main.tf
│ ├── variables.tf
│ └── outputs.tf

How to Execute
1. Initialize Terraform
terraform init

2. Validate Configuration
terraform validate

3. Plan Infrastructure
terraform plan --var-file=environments/dev.tfvars

4. Apply Infrastructure
terraform apply --var-file=environments/dev.tfvars