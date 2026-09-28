# Level 3 — EKS (Roadmap)

Managed Kubernetes on AWS (EKS) with worker nodes or Fargate profiles, ALB Ingress Controller, and private subnets.

**AWS services:** EKS, VPC CNI, ALB Ingress Controller / AWS Load Balancer Controller, IAM Roles for Service Accounts (IRSA), optionally ECR.

**Trade-offs:** More operational overhead than ECS Fargate; stronger fit for multi-service Kubernetes workloads and portable manifests. Higher cost and complexity for a small team.

**Status:** Roadmap — not implemented.
