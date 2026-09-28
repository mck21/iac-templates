<p align="center">
  <img src="https://img.shields.io/badge/AWS-CloudFormation-FF4F8B?style=for-the-badge&logo=amazonaws&logoColor=white&labelColor=FF4F8B" alt="CloudFormation"/>
  <img src="https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform"/>
</p>

# IaC Templates

AWS infrastructure templates with **CloudFormation** (learning basics) and **Terraform** (basics + portfolio scenarios).

> Scenarios are validated with `terraform validate` (and `fmt`). They are **not deployed** to AWS in this repository’s default workflow.

---

## Repository structure

```
iac-templates/
├── cloudformation/
│   └── basics/
│       ├── tasks/                        # Progressive CFN exercises
│       └── others/                       # Extra CFN examples
└── terraform/
    ├── basics/                           # Progressive TF exercises (01–07)
    ├── modules/                          # vpc, iam, s3, rds, alb, asg
    ├── business-growth/
    │   ├── level-1-startup/              # Implemented
    │   ├── level-2-growth/               # Implemented
    │   ├── level-3-ecs/                  # Roadmap (optional)
    │   └── level-3-eks/                  # Roadmap
    └── deployment-strategies/
        ├── README.md                     # Strategy comparison table
        ├── blue-green/                   # Implemented
        ├── canary/                       # Roadmap
        └── ab-testing/                   # Roadmap
```

---

## Scenario status

| Scenario | What it demonstrates | Status |
|----------|----------------------|--------|
| `terraform/basics/*` | Progressive TF exercises (VPC, EC2, S3, ALB, ASG, RDS) | Implemented (learning) |
| `cloudformation/basics/*` | Progressive CFN exercises | Implemented (learning) |
| `business-growth/level-1-startup` | VPC, SSM EC2, single-AZ RDS, S3, least-privilege IAM | Implemented |
| `business-growth/level-2-growth` | ALB + ASG, NAT, Multi-AZ RDS + replica, CloudWatch | Implemented |
| `business-growth/level-3-ecs` | ECS Fargate, Aurora Serverless v2, SQS/EventBridge | Roadmap |
| `business-growth/level-3-eks` | EKS | Roadmap |
| `deployment-strategies/blue-green` | Weighted ALB listener, dual ASG (`for_each`) | Implemented |
| `deployment-strategies/canary` | Gradual traffic shift | Roadmap |
| `deployment-strategies/ab-testing` | Rule-based traffic split | Roadmap |

---

## CloudFormation (basics)

```bash
# Example (requires AWS credentials — not part of offline validation)
aws cloudformation create-stack \
  --stack-name my-stack \
  --template-body file://cloudformation/basics/tasks/template01.yml \
  --parameters ParameterKey=CrearInstancia,ParameterValue=true
```

| CFN concept | Templates |
|---|---|
| Parameters + AllowedValues | All |
| Conditions | 01, 02, 03, 05, 06 |
| Rules | 01 |
| Mappings | 02, 04, 05, 06 |
| ALB + ASG | 03 |
| NAT + Peering | 04 |
| RDS Multi-AZ | 05 |
| S3 lifecycle | 06 |

---

## Terraform

### Basics

```bash
cd terraform/basics/01-test
terraform init
terraform plan
```

### Portfolio scenarios (offline validation)

```bash
cd terraform/business-growth/level-1-startup
terraform fmt -check -recursive
terraform init -backend=false
terraform validate

cd ../level-2-growth
terraform init -backend=false
terraform validate
```

| Terraform concept | Basics |
|---|---|
| provider / modules | All |
| VPC, subnets, IGW | All |
| EC2 | 01–03, 05, 07 |
| S3 | 04 |
| ALB | 05 |
| ASG | 06 |
| RDS | 07 |

---

> Learning templates and portfolio scenarios. Review AMI IDs, regions, and costs before any real deploy. Default portfolio region target: `eu-west-1`.
