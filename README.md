
# Cloud Devbox (AWS & Azure)

## ✅ Features
- Interactive instance selector with cost preview
- Daily snapshot automation (2AM Central)
- Optional high availability (HA) across AZs
- Placeholder for optional auto-shutdown on inactivity

## 🚀 Setup Instructions
1. Install:
   - Terraform
   - AWS CLI / Azure CLI
2. Authenticate:
   ```bash
   aws configure        # for AWS
   az login             # for Azure
   ```
3. Launch:
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```

## 🧠 What Happens
- Deploys EC2/VM + disk + IP
- Adds backup automation (14-day retention)
- (Optional) Adds second instance in HA AZ
- You get an SSH-ready cloud devbox

## 🛑 Stopping Your Instance
To stop manually:
```bash
aws ec2 stop-instances --instance-ids <id>
az vm deallocate --resource-group <rg> --name <vm>
```

## 🧹 Destroy Everything
```bash
terraform destroy -var-file=terraform.tfvars
```
