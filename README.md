# LogiNext — DevOps Programming Challenge

**Role:** Principal DevOps Engineer  
**Cloud Platform:** Amazon Web Services (AWS)  
**Infrastructure as Code:** Terraform  
**Operating System:** Amazon Linux 2023

## Project Overview

This repository contains the proposed architecture and infrastructure automation for a highly available, secure, scalable, and cost-optimized e-commerce platform on AWS.

The solution addresses the three tasks defined in the LogiNext DevOps Programming Challenge.

## Requirements
AWS account, AWS CLI configured with authorized credentials, Terraform >=1.5. AWS provider ~>5.0. Default region us-east-1. Ensure permissions for EC2, ELBv2, VPC, IAM and SSM parameter read.

## Task 1 — AWS Architecture Design

A production-oriented AWS architecture is proposed using:

- Amazon Route 53, CloudFront, AWS WAF and Application Load Balancer
- Amazon ECS with AWS Fargate for three Spring Boot microservices
- Amazon Aurora PostgreSQL, DynamoDB and ElastiCache
- Amazon S3 for file storage
- Amazon CloudWatch and OpenTelemetry for observability
- AWS IAM, Secrets Manager and KMS for security

**Deliverables:** Architecture diagram and technical design documentation. Production architecture documented in `architecture.md`.

## Task 2 — Automated AWS Infrastructure Provisioning

Terraform provisions the following resources:

- Custom AWS VPC
- Two public subnets across separate Availability Zones
- Private subnet for Apache EC2
- Internet Gateway and NAT Gateway
- Public and private route tables
- EC2 and ALB security groups
- IAM role and instance profile for AWS Systems Manager
- Amazon Linux 2023 EC2 instance
- Apache HTTP Server installed through EC2 User Data
- Internet-facing Application Load Balancer
- Target group and health checks

The EC2 instance has no public IPv4 address and receives application traffic through the ALB.

### Deployment

```bash
terraform init
terraform fmt
terraform validate
terraform plan -out=deployment.tfplan
terraform apply deployment.tfplan
```

### Validation

```bash
terraform output alb_url
```

Open the returned ALB URL to verify Apache availability.

### Cleanup

```bash
terraform destroy
```

## Task 3 — Cost Optimization and Auto Scaling

The proposed recommendations cover:

- Idle EC2 shutdown for eligible non-production environments
- CPU and memory-based ECS Service Auto Scaling
- Minimum and maximum microservice capacity
- Scale-in and scale-out behavior
- CloudWatch monitoring and alarms
- Scheduled scaling for anticipated traffic peaks

**Deliverables:** Cost and scaling recommendations in `scaling.md`.

## Security Considerations

- EC2 instances deployed in private subnets
- Security group-based application access
- IAM instance profile for AWS Systems Manager
- IMDSv2 enforced
- Encrypted EC2 root EBS volume
- Terraform state and sensitive files excluded from Git

## Implementation Scope

Task 1 and Task 3 provide production architecture and operational recommendations.

Task 2 is the deployed proof of concept. The Spring Boot microservices and production data services are not provisioned as part of this POC.

## Notes

The HTTP listener is used for the assignment demonstration. Production environments should use HTTPS with AWS Certificate Manager, additional resilience controls, and appropriately scoped IAM permissions.