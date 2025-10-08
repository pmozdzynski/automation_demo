# Automation Demo - Interview Explanation

## Tool Selection: Why Terraform + Ansible?

I chose **Terraform + Ansible** for this automation because it follows Infrastructure as Code best practices with clear separation of concerns:

- **Terraform**: Handles cloud infrastructure provisioning (server creation, networking, SSH keys)
- **Ansible**: Manages application deployment and configuration

**Why this combination?**
1. **Terraform** at cloud resource management with excellent state tracking
2. **Ansible** at configuration management and application deployment  
3. **Industry standard** approach - most DevOps teams use this pattern
4. **Hetzner Cloud integration** - Terraform's hcloud provider is mature and reliable
5. **Separation of concerns** - infrastructure vs. application configuration

**Alternatives considered:**
- Terraform alone: Lacks sophisticated config management
- Ansible alone: Poor state management for cloud resources
- Kubernetes: could be an alternative way with kapp

## Step-by-Step Automation Process

### Stage 1: Infrastructure Provisioning (Terraform)
1. **Authenticate** with Hetzner Cloud using `HCLOUD_TOKEN`
2. **Provision server**: `cpx11` instance in Helsinki with Docker CE image
3. **Configure networking**: Assign IPv4/IPv6 addresses and SSH access
4. **Generate inventory**: Create Ansible inventory file with connection details

### Stage 2: Application Deployment (Ansible)  
1. **Connect** to provisioned server using generated inventory
2. **Deploy files**: Copy custom `index.html` to server
3. **Orchestrate container**: 
   - Pull `nginx:latest` image
   - Create container with port mapping (80:80)
   - Mount custom HTML as read-only volume
4. **Ensure service**: Verify container is running and accessible

**Complete Flow:** `Developer → terraform apply → Hetzner Server → ansible-playbook → Nginx Container → Web App`

## Key Assumptions

**Infrastructure:**
- Hetzner Cloud account with API access
- SSH key `generic-key` exists in Hetzner account
- Internet connectivity for tool execution
- Available `cpx11` instances in Helsinki region

**Security:**
- Secure API token storage (`HCLOUD_TOKEN`)
- Private SSH key properly secured
- Root access for Docker operations (standard practice)
- Host key checking disabled for automation (demo acceptable)

**Environment:**
- Terraform and Ansible pre-installed
- Python 3 and Ansible Docker collection available
- Proper file permissions for SSH and inventory access

**Application:**
- Port 80 available on server
- Docker Hub accessible for image pulls
- `/tmp` directory writable with sufficient space
- Docker daemon running and functional

**Operational:**
- Terraform state files preserved between runs ( could be a central location for github/gitlab runners/pipelines )
- Idempotent Ansible playbook (safe to run multiple times)
- Manual cleanup via `terraform destroy`

This demonstrates Infrastructure as Code principles with reproducible, cloud-native deployment that separates infrastructure provisioning from application configuration.
