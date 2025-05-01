# do-vpn

A Terraform-based solution to set up a secure **site-to-site VPN** tunnel between **DigitalOcean** and **Azure**. This project provisions all necessary cloud infrastructure, including VPN gateways, virtual networks, and routing rules, to enable seamless communication between the two cloud platforms.

## 🌐 Overview

This repository:
- Deploys a **VPN server** on a DigitalOcean Droplet using `strongSwan`
- Configures an **Azure Virtual Network Gateway** with a local network gateway and a VPN connection
- Creates all required networking components: subnets, route tables, and public IPs
- Establishes a secure IPSec tunnel between Azure and DigitalOcean

## 🗂️ Directory Structure

```
do-vpn/
├── examples/
│   └── do-azure-vpn-setup/
│       ├── main.tf                  # Entry-point for running the setup
│       ├── provider.tf              # Provider configs (Azure + DO)
│       ├── terraform.tfvars         # User-defined secrets (excluded from Git)
│       ├── variables.tf             # Input variables
│       ├── versions.tf              # Provider versions
├── modules/
│   ├── digitalocean_vpn/
│   │   ├── main.tf                  # Creates DO VPN server and setup
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── azure_vnet/
│       ├── main.tf                  # Azure networking + VPN Gateway
│       ├── outputs.tf
│       └── variables.tf
```

## 🚀 Getting Started

### 🛠 Prerequisites

- [Terraform v1.3+](https://developer.hashicorp.com/terraform/install)
- Azure credentials (Service Principal)
- DigitalOcean API Token

### 🔐 `terraform.tfvars` Example

Create a `terraform.tfvars` file in `examples/do-azure-vpn-setup/` (do not commit this file):

```hcl
# DigitalOcean
do_token         = "your_digitalocean_token"

# Azure
client_id        = "your_azure_client_id"
client_secret    = "your_azure_client_secret"
tenant_id        = "your_azure_tenant_id"
subscription_id  = "your_azure_subscription_id"

# Custom VPN settings
location         = "East US"
resource_group   = "do-azure-vpn-rg"
droplet_name     = "vpn-server"
do_region        = "nyc3"
```

## 📦 Providers Used

```hcl
provider "digitalocean" {
  token = var.do_token
}

provider "azurerm" {
  features = {}
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}
```

## 📥 Input Variables

| Name             | Description                                  | Type   | Default     | Required |
|------------------|----------------------------------------------|--------|-------------|----------|
| `do_token`       | DigitalOcean API Token                       | string | n/a         | ✅ yes    |
| `client_id`      | Azure AD App Client ID                       | string | n/a         | ✅ yes    |
| `client_secret`  | Azure AD App Client Secret                   | string | n/a         | ✅ yes    |
| `tenant_id`      | Azure Tenant ID                              | string | n/a         | ✅ yes    |
| `subscription_id`| Azure Subscription ID                        | string | n/a         | ✅ yes    |
| `location`       | Azure Region                                 | string | `"East US"` | optional |
| `resource_group` | Name of Azure Resource Group                 | string | `"do-vpn"`  | optional |
| `droplet_name`   | Name for DigitalOcean VPN Droplet            | string | `"vpn"`     | optional |
| `do_region`      | DigitalOcean Region                          | string | `"nyc3"`    | optional |

## 📤 Outputs

| Name             | Description                                  |
|------------------|----------------------------------------------|
| `do_public_ip`   | Public IP of the DigitalOcean VPN server     |
| `azure_gateway_ip`| Azure Virtual Network Gateway Public IP     |
| `vpn_status`     | VPN connection status string                 |

## ✅ Usage

```bash
cd examples/do-azure-vpn-setup

# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply infrastructure
terraform apply
```

## 🧹 Cleanup

To destroy all resources:

```bash
terraform destroy
```

## 🔐 Security Best Practices

- Never commit sensitive files (`terraform.tfvars`, state files with secrets)
- Use `.gitignore` to exclude:
  ```
  .terraform/
  terraform.tfstate*
  terraform.tfvars
  ```
- Consider using:
  - [Terraform Cloud](https://app.terraform.io) for state management
  - [GitHub Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets) for CI/CD integration


