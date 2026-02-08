# Task-4: Private EC2 Deployment with Terraform, ALB, Docker & Strapi

## Project Overview
This project demonstrates a complete, production-style AWS infrastructure using Terraform.
A Strapi application is containerized using Docker, pushed to Docker Hub, and deployed on a
private EC2 instance. The application is accessed only via an Application Load Balancer (ALB).

The infrastructure is:
- Fully automated using Terraform
- Secure (private EC2, no SSH, no public IP)
- Modular and reusable
- Production-ready

---

## Objective
- Create a custom VPC
- Deploy EC2 in a private subnet
- Provide outbound internet using NAT Gateway
- Expose the application using ALB
- Secure access using Security Groups
- Run Strapi automatically using Docker
- Manage environment configs using tfvars

---

## Architecture

Internet
  |
  v
Application Load Balancer (Public Subnets)
  |
  v
Target Group (Port 1337)
  |
  v
Private EC2 Instance (Docker → Strapi)
  |
  v
NAT Gateway (Outbound Internet)

---

## Security Design
- EC2 has NO public IP
- SSH access removed
- EC2 allows inbound traffic ONLY from ALB Security Group
- ALB is the only public entry point
- Outbound traffic handled via NAT Gateway

---

## Repository Structure

Terraform_files/
├── main.tf
├── provider.tf
├── variables.tf
├── outputs.tf
├── environments/
│   └── dev.tfvars
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── ec2/
│   │   ├── main.tf
│   │   ├── security_group.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── userdata.sh
│   └── alb/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf

---

## Step-by-Step Implementation

### 1. VPC Module
- Created a custom VPC
- Created 2 public subnets (different AZs) for ALB
- Created 1 private subnet for EC2
- Attached Internet Gateway
- Created NAT Gateway in public subnet
- Configured route tables:
  - Public → Internet Gateway
  - Private → NAT Gateway

Reason:
Public-facing resources need internet access, while EC2 must remain private.

---

### 2. Creating Custom Strapi Docker Image

Why custom image:
- Official Strapi images caused native dependency issues
- Custom image ensures correct Node.js and Linux compatibility

Steps:
1. Created Strapi app locally
2. Wrote Dockerfile using node:20-alpine
3. Built image locally:
   docker build -t gauravjith/strapi:1.0 .
4. Pushed image to Docker Hub:
   docker push gauravjith/strapi:1.0

---

### 3. EC2 Module
- EC2 launched in private subnet
- No public IP
- Root volume size increased to 20GB
- Security Group:
  - Allow port 1337 only from ALB SG
- user_data.sh:
  - Install Docker
  - Start Docker service
  - Pull custom Strapi image
  - Run container automatically

No manual login required.

---

### 4. Application Load Balancer
- Internet-facing ALB
- Placed in public subnets
- ALB Security Group:
  - Allow HTTP (80) from 0.0.0.0/0
- Target Group:
  - Port: 1337
  - Health check path: /
  - Matcher: 200–399 (handles Strapi redirect)
- Listener:
  - Port 80 → Target Group

---

### 5. Making EC2 Fully Private
Removed:
- SSH ingress rule (port 22)
- Key pair attachment
- Public subnet usage
- Public IP assignment

Result:
- EC2 cannot be logged into
- Application accessible only via ALB

---

### 6. Terraform State Debugging
During GUI to Terraform migration:
- ALB security group deletion got stuck
- AWS showed no attached resources
- Terraform state caused blockage

Fix:
terraform state rm module.alb.aws_security_group.alb_sg

This removed stale state without deleting live infrastructure.

---

## Deployment Steps

terraform init
terraform validate
terraform apply -var-file="environments/dev.tfvars"

---

## Accessing the Application

Terraform output:
alb_dns_name = <output from terraform run>

Open in browser:
http://<alb_dns_name>

Strapi Admin UI loads successfully.

---

## Final Outcome
- Private EC2
- No SSH, no public IP
- Dockerized Strapi auto-starts
- Secure ALB access
- Modular Terraform setup
- Production-style architecture

---

## Conclusion
This project demonstrates real-world DevOps practices including secure AWS networking,
Terraform modularization, Docker automation, and infrastructure troubleshooting.
