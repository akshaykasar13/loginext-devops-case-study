# Task 3 — Cost Optimization and Scaling Recommendations

## Auto-stop recommendation
For **non-production** EC2 instances only, consider stopping when CPUUtilization averages below 5% over 60 minutes (12 consecutive 5-minute periods), **and** network activity, request count, scheduled jobs and business-hour criteria indicate idleness. Send a warning before stopping. Use EventBridge Scheduler + Lambda/SSM Automation to perform a guarded stop, with tag opt-in `AutoStop=true` and exemptions. Never stop critical production web nodes or ECS capacity solely because CPU is low. Stopping EC2 does not eliminate EBS storage charges; NAT, ALB and other resources may continue billing.

## Spring Boot ECS scaling policy (initial hypotheses; tune with load tests)
| Metric | Scale out | Scale in |
|---|---|---|
| CPU utilization | Target tracking 60%; sustained >70% for 5 min can justify additional step scaling | Sustained <30% for 15–20 min, only when other indicators are low |
| Memory utilization | Target tracking 70%; sustained >80% for 5 min | Sustained <45% for 20 min |
| ALB requests per target | Target tracking calibrated to tested capacity (e.g. 800 requests/target/min as a starting hypothesis) | Declining load with latency and error rates healthy |
| p95 latency | Alert and investigate if >500ms for 5 min (illustrative SLO) | Not a standalone scale-in trigger |
| HTTP 5xx | Alert if elevated above service SLO | Not a standalone scale-in trigger |

Set ECS service min desired count=2 (across AZs) and a capacity-tested max such as 20 per microservice; configure target tracking CPU/memory policies, scale-out cooldown around 60s, scale-in cooldown around 300s, and validate policies under load. Note target tracking automatically decides direction around the target, not fixed 70%/30% thresholds. Multiple target tracking policies generally scale out if any policy requires it and scale in only when all enabled policies agree. Prefer queue-depth-per-task for asynchronous workers, and scheduled pre-scaling for known sale windows.

## Savings
Right-size using CloudWatch/Compute Optimizer, Savings Plans for steady workloads, Spot for interruption-tolerant tasks, S3 lifecycle tiers, DynamoDB on-demand vs provisioned based on observed traffic, CloudWatch log retention, and VPC endpoints vs NAT cost analysis. Use AWS Budgets and cost allocation tags.
