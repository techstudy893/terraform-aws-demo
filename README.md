# Terraform AWS Lab

This project is a simple **Terraform lab** that provisions AWS resources using modular configuration.  
It’s designed as a hands-on demo for learning Terraform basics with AWS Free Tier.

---

## Prerequisites

- **Terraform** v1.6+ installed  
- **AWS account** with Free Tier enabled  
- **AWS CLI** installed and configured with a profile  

Set up your AWS credentials locally (on Mac/Linux/Windows):

```bash
aws configure --profile <profilename>
```
You will be prompted for:
- AWS Access Key ID
- AWS Secret Access Key
- Default region (e.g. eu-west-2)
- Output format (e.g. json)

This creates a profile stored in ~/.aws/credentials.
Your Terraform providers.tf will use that profile

## 📂 Project Structure
```text
terraform-aws-lab
├── backend
├── main.tf
├── modules
│   ├── s3site
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   ├── vpc
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── web
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── outputs.tf
├── plan.out
├── providers.tf
├── terraform.tfvars
├── variables.tf
└── versions.tf
```
---

## What It Deploys
- **VPC module** → custom VPC, public subnet, internet gateway, route table  
- **Web module** → EC2 instance(s) running Nginx, IAM role with S3 read access  
- **S3 Site module** → S3 bucket with optional static website hosting  

---

## Usage

1. **Clone this repo**
   ```bash
   git clone https://github.com/techstudy893/terraform-aws-demo.git
   cd terraform-aws-lab
   ```
2. **Initialize Terraform**
   ```bash 
   terraform init
   ```
3. **Validate and Plan**
   ```bash
   terraform validate
   terraform plan
   ```
4. **Apply the configuration**
   ```bash
   terraform apply
   ```
5. **Destroy when finished**   
   ```bash
   terraform destroy
   ```

