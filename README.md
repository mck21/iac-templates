<p align="center">
  <img src="https://img.shields.io/badge/AWS-CloudFormation-ff69b4?style=for-the-badge&logo=amazonaws&logoColor=white" alt="CloudFormation"/>
  <img src="https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform"/>
</p>

# 🏗️ IaC Templates

A monorepo of AWS infrastructure templates using **CloudFormation** and **Terraform**, organised as progressive practical exercises. They cover from basic networking to high availability architectures with load balancing, databases and storage.

---

## 📁 Repository structure

```
iac-templates/
├── cloudformation/
│   ├── tasks/                        # Exercise templates (progressive)
│   │   ├── template01.yml            # VPC + public subnet + conditional EC2
│   │   ├── template02.yml            # Multi-region VPC with Mappings + conditional IGW
│   │   ├── template03.yml            # ALB + Multi-AZ Auto Scaling Group
│   │   ├── template04.yml            # HA VPC with NAT Gateway + VPC Peering
│   │   ├── template05.yml            # Multi-AZ RDS MySQL in private subnets
│   │   └── template06.yml            # S3 Bucket with access policies and lifecycle
│   └── others/                       # Test templates
│       ├── hola.yml                  # Basic VPC + subnet + EC2 (first template)
│       ├── mappings.yml              # Mappings usage example
│       ├── rds.yml                   # Basic standalone RDS
│       └── rules1.yml                # Rules and validations example
├── terraform/
│   └── 01-test/                      # Infrastructure with modular approach
│       ├── modules/
│       │   ├── ec2/                  # EC2 instance and Security Group module
│       │   └── vpc/                  # VPC, Subnets, IGW, and Routing module
│       ├── main.tf                   # Main configuration calling modules
│       └── variables.tf              # Global variables
└── README.md
```

---

## ☁️ CloudFormation

### 🚀 Deploy

```bash
# Validate before creating
aws cloudformation validate-template --template-body file://cloudformation/tasks/template01.yml

# Create stack
aws cloudformation create-stack \
  --stack-name my-stack \
  --template-body file://cloudformation/tasks/template01.yml \
  --parameters ParameterKey=CreateInstance,ParameterValue=true

# View outputs
aws cloudformation describe-stacks \
  --stack-name my-stack \
  --query 'Stacks[0].Outputs'

# Delete stack
aws cloudformation delete-stack --stack-name my-stack
```

### 🛠️ Concepts covered

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

## 🏗️ Terraform

### 🚀 Deploy

```bash
# Initialise Terraform (download providers)
terraform init

# Preview changes before applying
terraform plan

# Apply infrastructure
terraform apply

# Destroy infrastructure
terraform destroy
```

### 🛠️ Concepts covered

| Terraform Concept | Templates |
|---|---|
| `provider` (AWS region) | 01 |
| `aws_vpc` | 01 |
| `aws_subnet` (public, `map_public_ip_on_launch`) | 01 |
| `aws_internet_gateway` | 01 |
| `aws_route_table` + `aws_route_table_association` | 01 |
| `aws_security_group` (SSH + HTTP ingress) | 01 |
| `aws_instance` (EC2 + key pair + tags) | 01 |

---

> Templates designed for learning environments. AMIs, key names and some configurations are region-specific — review values before deploying to production.