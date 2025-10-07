# Automation Demo - Terraform + Ansible

This project demonstrates infrastructure automation using Terraform to provision infrastructure and Ansible to configure applications on Hetzner Cloud.

## What it does

1. **Provisions Infrastructure**: Terraform creates a Hetzner Cloud server with Docker CE pre-installed
2. **Configures Application**: Ansible deploys a custom HTML page and runs an Nginx Docker container
3. **Two-Stage Process**: Infrastructure first, then application configuration

## Architecture

- **Infrastructure**: Terraform + Hetzner Cloud (hcloud)
- **Configuration**: Ansible + Docker
- **Server**: cpx11 (smallest AMD server) in Helsinki
- **OS**: Docker CE image
- **Application**: Nginx container serving custom "Hello from Automation" page

## Prerequisites

- Terraform installed
- Ansible installed with Docker collection
- Hetzner Cloud account and API token
- SSH key configured in Hetzner Cloud

## Usage

1. Set your Hetzner Cloud token:
   ```bash
   export HCLOUD_TOKEN="your-token-here"
   ```

2. Provision infrastructure with Terraform:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

3. Configure application with Ansible:
   ```bash
   ansible-playbook -i inventory playbook.yaml
   ```

4. Access your application:
   - The server IP will be displayed in the Terraform output
   - Visit `http://<server-ip>` to see "Hello from Automation"

## Cleanup

To destroy the infrastructure:
```bash
terraform destroy
```

## Files

- `main.tf` - Terraform configuration for infrastructure
- `playbook.yaml` - Ansible playbook for application deployment
- `ansible.cfg` - Ansible configuration
- `inventory` - Terraform-generated Ansible inventory
- `roles/webserver/` - Ansible role for web server configuration
- `terraform.tfstate*` - Terraform state files (do not edit manually)

## Ansible Role Structure

```
roles/webserver/
├── tasks/main.yml      # Main deployment tasks
├── handlers/main.yml   # Container restart handler
└── files/index.html    # Custom HTML content
```
