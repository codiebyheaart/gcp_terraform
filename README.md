# GCP Terraform Configuration

Terraform configuration for deploying a Compute Engine instance on Google Cloud Platform with VPC networking.

## 📋 Resources Created

- **VPC Network**: Custom VPC with configurable CIDR
- **Subnet**: Regional subnet within the VPC
- **Firewall Rules**: SSH, HTTP, and HTTPS access
- **Static IP**: Reserved external IP address
- **Compute Instance**: VM instance with customizable specifications

## 🔧 Prerequisites

### 1. Install Required Tools

```bash
# Install Terraform
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Install Google Cloud SDK
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
gcloud init
```

### 2. GCP Setup

```bash
# Login to GCP
gcloud auth login

# Set your project
gcloud config set project YOUR_PROJECT_ID

# Enable required APIs
gcloud services enable compute.googleapis.com
gcloud services enable servicenetworking.googleapis.com
```

### 3. Create Service Account (Recommended)

```bash
# Create service account
gcloud iam service-accounts create terraform-sa \
  --display-name="Terraform Service Account"

# Grant necessary permissions
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
  --member="serviceAccount:terraform-sa@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/compute.admin"

gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
  --member="serviceAccount:terraform-sa@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"

# Create and download key
gcloud iam service-accounts keys create ~/gcp-terraform-key.json \
  --iam-account=terraform-sa@YOUR_PROJECT_ID.iam.gserviceaccount.com
```

## 🚀 Quick Start

### 1. Configure Variables

```bash
# Copy example variables file
cp terraform.tfvars.example terraform.tfvars

# Edit with your values
vim terraform.tfvars
```

### 2. Set Authentication

**Option A: Using Service Account Key**
```bash
export GOOGLE_APPLICATION_CREDENTIALS="~/gcp-terraform-key.json"
```

**Option B: Using Application Default Credentials**
```bash
gcloud auth application-default login
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review Plan

```bash
terraform plan
```

### 5. Deploy Infrastructure

```bash
terraform apply
```

### 6. Get Outputs

```bash
terraform output
```

## 📝 Configuration Variables

### Required Variables

| Variable | Description | Example |
|----------|-------------|----------|
| `project_id` | GCP Project ID | `my-project-123456` |

### Optional Variables

| Variable | Description | Default |
|----------|-------------|----------|
| `region` | GCP region | `us-central1` |
| `zone` | GCP zone | `us-central1-a` |
| `instance_name` | VM instance name | `terraform-instance` |
| `machine_type` | Instance type | `e2-medium` |
| `boot_disk_size` | Boot disk size (GB) | `20` |
| `ssh_user` | SSH username | `terraform` |

## 🔐 SSH Access

### Generate SSH Key (if needed)

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f ~/.ssh/id_rsa
```

### Connect to Instance

```bash
# Get connection string from outputs
terraform output ssh_connection

# Or manually
ssh terraform@<EXTERNAL_IP>
```

## 🌐 Available Machine Types

### General Purpose (E2)
- `e2-micro` - 2 vCPUs, 1 GB RAM
- `e2-small` - 2 vCPUs, 2 GB RAM
- `e2-medium` - 2 vCPUs, 4 GB RAM (default)
- `e2-standard-2` - 2 vCPUs, 8 GB RAM
- `e2-standard-4` - 4 vCPUs, 16 GB RAM

### Compute Optimized (C2)
- `c2-standard-4` - 4 vCPUs, 16 GB RAM
- `c2-standard-8` - 8 vCPUs, 32 GB RAM

### Memory Optimized (M2)
- `m2-ultramem-208` - 208 vCPUs, 5.7 TB RAM

## 🖼️ Available Images

```hcl
# Debian
boot_disk_image = "debian-cloud/debian-11"
boot_disk_image = "debian-cloud/debian-12"

# Ubuntu
boot_disk_image = "ubuntu-os-cloud/ubuntu-2004-lts"
boot_disk_image = "ubuntu-os-cloud/ubuntu-2204-lts"

# CentOS
boot_disk_image = "centos-cloud/centos-7"
boot_disk_image = "centos-cloud/centos-stream-9"

# Red Hat
boot_disk_image = "rhel-cloud/rhel-8"
boot_disk_image = "rhel-cloud/rhel-9"
```

## 🔄 Common Operations

### Update Instance

```bash
# Modify variables in terraform.tfvars
terraform plan
terraform apply
```

### Destroy Infrastructure

```bash
terraform destroy
```

### View State

```bash
terraform show
```

### Import Existing Resources

```bash
terraform import google_compute_instance.vm_instance projects/PROJECT_ID/zones/ZONE/instances/INSTANCE_NAME
```

## 🛡️ Security Best Practices

1. **Restrict SSH Access**
   ```hcl
   allowed_ssh_sources = ["YOUR_IP/32"]
   ```

2. **Use Service Accounts**
   - Don't use personal credentials
   - Create dedicated service accounts
   - Apply least privilege principle

3. **Enable Encryption**
   - Boot disks are encrypted by default
   - Consider customer-managed encryption keys (CMEK)

4. **Use Private IPs**
   - For production, use Cloud NAT instead of public IPs
   - Implement VPC Service Controls

5. **Enable VPC Flow Logs**
   - Already enabled in subnet configuration
   - Review logs regularly

## 💰 Cost Estimation

### e2-medium Instance (Default)
- **Compute**: ~$24/month (730 hours)
- **Storage**: ~$2/month (20 GB standard disk)
- **Network**: Variable (first 1 GB egress free)
- **Static IP**: ~$7/month (if not attached to running instance)

**Total**: ~$33/month

### Cost Optimization Tips

1. Use preemptible instances for non-critical workloads (60-91% discount)
   ```hcl
   preemptible = true
   ```

2. Use committed use discounts (up to 57% discount)

3. Right-size your instances

4. Use sustained use discounts (automatic)

## 🔍 Troubleshooting

### Authentication Errors

```bash
# Verify authentication
gcloud auth list

# Re-authenticate
gcloud auth application-default login
```

### API Not Enabled

```bash
# Enable Compute Engine API
gcloud services enable compute.googleapis.com
```

### Quota Exceeded

```bash
# Check quotas
gcloud compute project-info describe --project=PROJECT_ID

# Request quota increase in GCP Console
```

### SSH Connection Issues

```bash
# Check firewall rules
gcloud compute firewall-rules list

# Verify instance is running
gcloud compute instances list

# Check SSH in browser (GCP Console)
```

## 📚 Additional Resources

- [GCP Compute Engine Documentation](https://cloud.google.com/compute/docs)
- [Terraform GCP Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [GCP Pricing Calculator](https://cloud.google.com/products/calculator)
- [GCP Free Tier](https://cloud.google.com/free)

## 🤝 Support

For issues or questions:
1. Check GCP Console for resource status
2. Review Terraform state: `terraform show`
3. Enable debug logging: `export TF_LOG=DEBUG`
4. Check GCP logs in Cloud Logging

---

**Note**: Always review the Terraform plan before applying changes to production environments.
