# Task 1 — Proposed Production Architecture

**Use case:** high-traffic e-commerce platform with three Spring Boot services (MSA1, MSA2, MSA3).

## Request path
Customers → Route 53 → CloudFront + AWS WAF → public ALB (HTTPS) → private ECS Fargate services (MSA1/MSA2/MSA3) across two or more AZs. A static web frontend may be hosted on private S3 with CloudFront Origin Access Control. For dynamic server-rendered pages use a dedicated ECS web service.

## Data and supporting services
- SQL: Aurora PostgreSQL with appropriate Multi-AZ availability, automated backups and PITR.
- NoSQL: DynamoDB on-demand, point-in-time recovery, least-privilege IAM.
- Cache: ElastiCache for Valkey, multi-AZ replication/failover when justified.
- Files: private S3 buckets with block public access, versioning, encryption and lifecycle policies; CloudFront OAC for static content.
- Logging: CloudWatch Logs with structured JSON and retention policies; ALB access logs in S3.
- Monitoring: CloudWatch metrics/alarms, AWS Distro for OpenTelemetry traces, dashboards and alert notifications.

## Security
Public subnets contain ALB; application tasks in private subnets; Aurora/ElastiCache in isolated data subnets. Use security-group references, ACM TLS, WAF managed rules, Shield Standard, Secrets Manager, KMS encryption, IAM least privilege, ECS task roles, CloudTrail and AWS Config. Use VPC endpoints for S3/DynamoDB and other AWS APIs where appropriate. Use NAT for remaining required egress with egress controls.

## Reliability and operations
Run at least two tasks per critical ECS service across AZs. Health checks, rolling or blue/green deployments, separate autoscaling policies per service, deployment rollback, RDS backups and restore drills. Consider SQS to buffer asynchronous order-related work, idempotency keys, and load testing before major sales events. Use RDS Proxy if database connection counts become a bottleneck.

## Tradeoffs
ECS Fargate reduces host management but may cost more at sustained high utilization. Aurora and multi-AZ caching add cost but improve resilience. NAT gateways have hourly and per-GB charges. The POC deploys a simplified, less resilient architecture to satisfy Task 2 without incurring production-scale cost.
