#!/bin/bash

echo "Choose your cloud provider:"
select cloud in "aws" "azure"; do
  case $cloud in
    aws ) break;;
    azure ) break;;
    * ) echo "Invalid option";;
  esac
done

if [ "$cloud" = "aws" ]; then
  echo "Choose your AWS instance type:"
  select instance in \
    "t3a.medium - 2 vCPU / 4 GB RAM - $0.0376/hr" \
    "t3a.large - 2 vCPU / 8 GB RAM - $0.0752/hr [RECOMMENDED]" \
    "t3a.xlarge - 4 vCPU / 16 GB RAM - $0.1504/hr" \
    "t4g.medium - 2 vCPU / 4 GB RAM (ARM) - $0.0336/hr" \
    "t4g.xlarge - 4 vCPU / 16 GB RAM (ARM) - $0.1344/hr" \
    "m5.large - 2 vCPU / 8 GB RAM (dedicated CPU) - $0.096/hr"; do
    case $instance in
      *t3a.medium* ) instance_type="t3a.medium"; hourly=0.0376; break;;
      *t3a.large* ) instance_type="t3a.large"; hourly=0.0752; break;;
      *t3a.xlarge* ) instance_type="t3a.xlarge"; hourly=0.1504; break;;
      *t4g.medium* ) instance_type="t4g.medium"; hourly=0.0336; break;;
      *t4g.xlarge* ) instance_type="t4g.xlarge"; hourly=0.1344; break;;
      *m5.large* ) instance_type="m5.large"; hourly=0.096; break;;
    esac
  done
else
  echo "Choose your Azure instance type:"
  select instance in \
    "B2s - 2 vCPU / 4 GB RAM - $0.0416/hr" \
    "B2ms - 2 vCPU / 8 GB RAM - $0.0752/hr" \
    "B4ms - 4 vCPU / 16 GB RAM - $0.1465/hr" \
    "D2s_v3 - 2 vCPU / 8 GB RAM (stable CPU) - $0.096/hr" \
    "F4s_v2 - 4 vCPU / 8 GB RAM (CPU-optimized) - $0.170/hr"; do
    case $instance in
      *B2s* ) instance_type="B2s"; hourly=0.0416; break;;
      *B2ms* ) instance_type="B2ms"; hourly=0.0752; break;;
      *B4ms* ) instance_type="B4ms"; hourly=0.1465; break;;
      *D2s_v3* ) instance_type="D2s_v3"; hourly=0.096; break;;
      *F4s_v2* ) instance_type="F4s_v2"; hourly=0.170; break;;
    esac
  done
fi

echo "Choose Region:"
if [ "$cloud" = "aws" ]; then
  select region in "us-east-1" "us-west-1" "us-west-2" "ca-central-1" "eu-central-1" "ap-northeast-1"; do
    break
  done
else
  select region in "eastus" "eastus2" "westus" "southcentralus" "westeurope" "japaneast"; do
    break
  done
fi

read -p "Disk size in GB (e.g. 32): " disk
read -p "How many hours per month will you run this (e.g. 100): " hours
read -p "Enable daily snapshots with 14-day retention? (yes/no): " enable_snapshots
read -p "Enable high availability (HA) with a second instance? (yes/no): " enable_ha

enable_snapshots=$(echo "$enable_snapshots" | tr '[:upper:]' '[:lower:]')
enable_ha=$(echo "$enable_ha" | tr '[:upper:]' '[:lower:]')

monthly_cost=$(echo "$hourly * $hours" | bc)
printf "\\nEstimated monthly compute cost: $%.2f\\n\\n" "$monthly_cost"

# Credential Check
if [ "$cloud" = "aws" ]; then
  if ! aws sts get-caller-identity &>/dev/null; then
    echo "❌ AWS credentials not found. Run 'aws configure' first."
    exit 1
  fi
else
  if ! az account show &>/dev/null; then
    echo "❌ Azure CLI not logged in. Run 'az login' first."
    exit 1
  fi
fi

# Save to terraform.tfvars
cat > terraform.tfvars <<EOF
cloud             = "$cloud"
instance_type     = "$instance_type"
disk              = $disk
region            = "$region"
enable_snapshots  = "$enable_snapshots"
enable_ha         = "$enable_ha"
EOF

terraform init
terraform apply -var-file="terraform.tfvars"

