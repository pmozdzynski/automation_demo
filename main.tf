  terraform {
    required_providers {
      hcloud = {
        source  = "hetznercloud/hcloud"
        version = "~> 1.54.0"
      }
      null = {
        source  = "hashicorp/null"
        version = "~> 3.2.0"
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

  # Create the custom index.html file on the server
  resource "null_resource" "deploy_web_content" {
    depends_on = [hcloud_server.web]
    
    connection {
      type        = "ssh"
      host        = hcloud_server.web.ipv4_address
      user        = "root"
      private_key = file("~/.ssh/id_rsa")
    }

    provisioner "file" {
      content = <<-EOT
<!DOCTYPE html>
<html>
<head>
    <title>Automation Test</title>
</head>
<body>
    <h1>Hello from Automation</h1>
</body>
</html>
EOT
      destination = "/tmp/index.html"
    }

    provisioner "remote-exec" {
      inline = [
        "docker run -d --name hello -p 80:80 -v /tmp/index.html:/usr/share/nginx/html/index.html:ro nginx:latest"
      ]
    }
  }

  output "ipv4" {
    value = hcloud_server.web.ipv4_address
  }

  output "ipv6" {
    value = hcloud_server.web.ipv6_address
  }
