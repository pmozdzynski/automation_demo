# Automation Demo - Web Server + GitHub Runner

This project demonstrates a complete automation setup using Terraform and Ansible to provision both a web server and a GitHub self-hosted runner on Hetzner Cloud.

## What it does

1. **Provisions Infrastructure**: Terraform creates two Hetzner Cloud servers:
   - Web server with Docker CE for hosting applications
   - GitHub self-hosted runner for CI/CD automation
2. **Configures Applications**: Ansible deploys:
   - Nginx web server with custom HTML content
   - GitHub Actions self-hosted runner with Terraform support
3. **Complete CI/CD Pipeline**: Enables automated deployments and testing

## Architecture

- **Infrastructure**: Terraform + Hetzner Cloud (hcloud)
- **Configuration**: Ansible + Docker
- **Web Server**: cpx11 server with Nginx container serving "Hello from Automation"
- **GitHub Runner**: cpx11 server with GitHub Actions runner and Terraform
- **Location**: Helsinki (hel1)
- **SSH Keys**: Both servers use "generic-key" and "github-runner" keys

## Prerequisites

- Terraform installed
- Ansible installed with Docker collection
- Hetzner Cloud account and API token
- GitHub repository with Actions enabled
- SSH keys configured in Hetzner Cloud
- GitHub runner token (from repository settings)

## Environment Variables

Set the following environment variables:

```bash
# Hetzner Cloud API token
export HCLOUD_TOKEN="your-hetzner-token"

# GitHub runner registration token
export GITHUB_RUNNER_TOKEN="your-github-runner-token"

# SSH private key for runner access
export RUNNER_SSH_PRIVATE_KEY="$(cat ~/.ssh/id_rsa_hetzner_runner)"
```

## Usage

1. **Provision infrastructure with Terraform:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

2. **Configure applications with Ansible:**
   ```bash
   ansible-playbook -i inventory playbook.yaml
   ```

3. **Access your services:**
   - **Web Server**: Visit `http://<web-server-ip>` to see "Hello from Automation"
   - **GitHub Runner**: Check your GitHub repository's Actions tab for the new runner

## Infrastructure Details

### Web Server
- **Server Type**: cpx11 (smallest AMD server)
- **OS**: Docker CE
- **Application**: Nginx container with custom HTML
- **Port**: 80 (HTTP)

### GitHub Runner
- **Server Type**: cpx11 (smallest AMD server)  
- **OS**: Docker CE
- **User**: `github` (dedicated user for runner)
- **Tools**: Terraform 1.13.3, GitHub Actions runner v2.328.0
- **Service**: Systemd service for automatic startup
- **Repository**: Connected to `pmozdzynski/automation_demo`

## Files Structure

```
automation_demo/
├── main.tf                    # Terraform configuration
├── playbook.yaml             # Ansible playbook
├── ansible.cfg               # Ansible configuration
├── inventory                 # Terraform-generated inventory
├── roles/
│   ├── webserver/           # Web server role
│   │   ├── tasks/main.yml   # Web server tasks
│   │   ├── handlers/main.yml # Container restart handler
│   │   └── files/index.html # Custom HTML content
│   └── runner/              # GitHub runner role
│       └── tasks/main.yml   # Runner setup tasks
└── terraform.tfstate*       # Terraform state files
```

## Ansible Roles

### Web Server Role (`roles/webserver/`)
- Copies custom HTML file to server
- Deploys and manages Nginx Docker container
- Handles container restarts when content changes

### Runner Role (`roles/runner/`)
- Creates dedicated `github` user
- Sets up SSH keys for runner access
- Installs Terraform 1.13.3
- Downloads and configures GitHub Actions runner
- Registers runner with GitHub repository
- Creates and starts systemd service

## Outputs

Terraform provides the following outputs:
- `web_ipv4` - Web server IPv4 address
- `web_ipv6` - Web server IPv6 address  
- `runner_ipv4` - GitHub runner IPv4 address
- `runner_ipv6` - GitHub runner IPv6 address

## Cleanup

To destroy the infrastructure:
```bash
terraform destroy
```

**Note**: Make sure to remove the GitHub runner from your repository settings before destroying the infrastructure.

## GitHub Runner Features

The self-hosted runner includes:
- **Terraform**: For infrastructure automation
- **Docker**: For containerized workflows
- **SSH Access**: For secure deployments
- **Automatic Registration**: Runner is automatically registered with your repository
- **Service Management**: Runs as a systemd service for reliability

## Security Notes

- SSH keys are properly configured with correct permissions
- Runner runs under dedicated `github` user (not root)
- Private keys are stored securely with 600 permissions
- Runner is configured for unattended operation
