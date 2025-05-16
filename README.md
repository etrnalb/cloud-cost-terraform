# ☁️ Cloud Devbox (AWS + Azure)

Deploy a fully interactive, cost-efficient cloud-based devbox using Terraform. Supports both AWS and Azure, snapshot automation, high availability (HA), and optional auto-shutdown for inactive instances.

---

## ✅ Features

- 🌐 Deploy to **AWS** or **Azure**
- ⚙️ Choose instance specs interactively (vCPU, RAM, region)
- 💰 Built-in **cost estimator**: shows how much your instance will cost per month before deploying
- 💾 **Daily snapshot automation** at 2AM Central with 14-day retention
- 🔄 Optional **High Availability**: 2 instances across AZs
- 💤 Optional **inactivity-based auto-shutdown** (stops instance if no SSH users)

---

## 🚀 How to Use

### 1. **Install Tools**
Make sure you have:
- Terraform (`brew install terraform`)
- AWS CLI (`aws configure`)
- Azure CLI (`az login`)

---

### 2. **Launch Setup Script**
From the repo folder:

```bash
chmod +x setup.sh
./setup.sh

