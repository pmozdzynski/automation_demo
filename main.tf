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

  resource "hcloud_server" "web" {
    name        = "web-automation-piotr"
    image       = "docker-ce"  # x86_64 supported
    server_type = "cpx11"             # smallest AMD server
    ssh_keys    = ["generic-key"]     # Existing Hetzner key
    location    = "hel1"              # Helsinki
  }

# Generate a local inventory file for Ansible with SSH options to ignore host key checking ( when hetzner provided new server ) 
resource "local_file" "ansible_inventory" {
  content = <<EOT
[web]
${hcloud_server.web.ipv4_address} ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOT
  filename = "${path.module}/inventory"
}

  output "ipv4" {
    value = hcloud_server.web.ipv4_address
  }

  output "ipv6" {
    value = hcloud_server.web.ipv6_address
  }
