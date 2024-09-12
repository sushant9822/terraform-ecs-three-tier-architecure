# AWS Three Tie Architecture Setup with Terraform

## Overview

This repository contains Terraform configurations for setting up a tiered architecture on AWS. It follows best practices for scalability, security, and manageability, leveraging various AWS services to create a robust infrastructure.

## Architecture Diagram

![Architecture Diagram](path-to-your-architecture-image)

## Directory Structure

The project is organized into directories representing different AWS services and components:

- `alb` - Application Load Balancer
- `cloudfront` - AWS CloudFront
- `ecr` - Amazon Elastic Container Registry
- `ecs` - Amazon Elastic Container Service (clusters and services)
- `openvpn` - OpenVPN setup
- `rds` - Amazon RDS
- `redis` - Redis
- `vpc` - AWS Virtual Private Cloud

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine
- An AWS account with appropriate permissions
- AWS CLI configured with your credentials
- An S3 bucket for storing Terraform state files (optional, if using remote state)

## Getting Started

### Clone the Repository

```bash
git clone https://github.com/your-username/your-repo.git
cd your-repo
```
### Configuration
1. Update Variables:
   Navigate to specific directory example: ECS, RDS, ALB, VPC etc
   Edit terraform.tfvars or use environment variables to set the required values for your setup.
   
3. Initialize Terraform:
   ```bash
    terraform init
   ```
4. Create Terraform workspace
   ```bash
   terraform workspace new <workspace name>
   ```
5. Plan the Infrastructure:
   ```bash
   terraform plan
   ```
6. Apply the Configuration:
   ```bash
   terraform apply
   ```


   

