terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.54.0"
    }
  }
}

provider "hcloud" {
  # Terraform automatically picks up HCLOUD_TOKEN from the environment
}

# ------------------------------
# Web server (Docker + Nginx)
# ------------------------------
resource "hcloud_server" "web" {
  name        = "web-automation-piotr-1"
  image       = "docker-ce"        # x86_64 supported
  server_type = "cpx11"            # smallest AMD server
  ssh_keys    = ["generic-key", "github-runner"]    # Existing Hetzner key + github-runner key
  location    = "hel1"             # Helsinki
}

# ------------------------------
# Generate Ansible inventory
# ------------------------------
resource "local_file" "ansible_inventory" {
  content = <<EOT
[web]
${hcloud_server.web.ipv4_address} ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOT
  filename = "${path.module}/inventory"
}

# ------------------------------
# Outputs
# ------------------------------
output "web_ipv4" {
  value = hcloud_server.web.ipv4_address
}

output "web_ipv6" {
  value = hcloud_server.web.ipv6_address
}
