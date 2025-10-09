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
  count       = var.server_count  # Dynamically scale the number of servers
  name        = "web-automation-piotr-${count.index + 1}"
  image       = "docker-ce"
  server_type = "cpx11"
  ssh_keys    = ["generic-key", "github-runner"]
  location    = "hel1"
}

resource "local_file" "ansible_inventory" {
  content = <<EOT
[web]
%{ for i in range(var.server_count) }
${hcloud_server.web[i].ipv4_address} ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_rsa ansible_ssh_common_args='-o StrictHostKeyChecking=no'
%{ endfor }
EOT
  filename = "${path.module}/inventory"
}

output "web_ipv4" {
  value = [for server in hcloud_server.web : server.ipv4_address]
}


output "web_ipv6" {
  value = [for server in hcloud_server.web : server.ipv6_address]
}
