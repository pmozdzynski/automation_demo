# Automation Demo - Terraform Only

This project demonstrates infrastructure automation using Terraform to provision and configure a web server on Hetzner Cloud.

## What it does

1. **Provisions Infrastructure**: Creates a Hetzner Cloud server with Docker CE pre-installed
2. **Deploys Web Application**: Automatically deploys a custom HTML page using Docker
3. **No Ansible Required**: Everything is handled by Terraform provisioners

## Architecture

- **Provider**: Hetzner Cloud (hcloud)
- **Server**: cpx11 (smallest AMD server) in Helsinki
- **OS**: Docker CE image
- **Application**: Nginx container serving custom "Hello from Automation" page

## Usage

1. Set your Hetzner Cloud token:
   ```bash
   export HCLOUD_TOKEN="your-token-here"
   ```

2. Initialize and apply:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

3. Access your application:
   - The server IP will be displayed in the output
   - Visit `http://<server-ip>` to see "Hello from Automation"

## Cleanup

To destroy the infrastructure:
```bash
terraform destroy
```

## Files

- `main.tf` - Main Terraform configuration
- `terraform.tfstate*` - Terraform state files (do not edit manually)
