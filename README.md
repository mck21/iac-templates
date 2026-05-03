<p align="center">
  <img src="https://img.shields.io/badge/AWS-CloudFormation-ff69b4?style=for-the-badge&logo=amazonaws&logoColor=white" alt="CloudFormation"/>
</p>

# ☁️ CloudFormation Templates

A collection of AWS CloudFormation templates organised as progressive practical exercises. They cover from basic networking to high availability architectures with load balancing, databases and storage.

---

## 📁 Repository structure

```
cloudformation-templates/
├── templates/
│   ├── tasks/                     # Exercise templates (progressive)
│   │   ├── template01.yml            # VPC + public subnet + conditional EC2
│   │   ├── template02.yml            # Multi-region VPC with Mappings + conditional IGW
│   │   ├── template03.yml            # ALB + Multi-AZ Auto Scaling Group
│   │   ├── template04.yml            # HA VPC with NAT Gateway + VPC Peering
│   │   ├── template05.yml            # Multi-AZ RDS MySQL in private subnets
│   │   └── template06.yml            # S3 Bucket with access policies and lifecycle
│   └── others/                    # Test templates
│       ├── hola.yml                  # Basic VPC + subnet + EC2 (first template)
│       ├── mappings.yml              # Mappings usage example
│       ├── rds.yml                   # Basic standalone RDS
│       └── rules1.yml                # Rules and validations example
└── README.md
```

---

## 🚀 Deploying a template

```bash
# Validate before creating
aws cloudformation validate-template --template-body file://templates/tasks/template01.yml

# Create stack
aws cloudformation create-stack \
  --stack-name my-stack \
  --template-body file://templates/tasks/template01.yml \
  --parameters ParameterKey=CreateInstance,ParameterValue=true

# View outputs
aws cloudformation describe-stacks \
  --stack-name my-stack \
  --query 'Stacks[0].Outputs'

# Delete stack
aws cloudformation delete-stack --stack-name my-stack
```

---

## 🛠️ Resources and concepts covered

| CFN Concept | Templates |
|---|---|
| `Parameters` + `AllowedValues` | All |
| `Conditions` + `!Equals` / `!If` | 01, 02, 03, 05, 06 |
| `Rules` + `Assertions` | 01 |
| `Mappings` + `!FindInMap` | 02, 04, 05, 06 |
| `!GetAZs` + `!Select` | 01, 02, 03, 04 |
| VPC Peering | 04 |
| NAT Gateway | 04 |
| ALB + ASG + Launch Template | 03 |
| RDS Multi-AZ + Parameter Group | 05 |
| S3 lifecycle + bucket policies | 06 |
| Outputs with `Export` | 04, 05, 06 |

---

> Templates designed for learning environments. Some AMIs and configurations are region-specific — review values before deploying to production.