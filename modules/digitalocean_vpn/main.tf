terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

resource "digitalocean_droplet" "vpn" {
  name     = var.droplet_name
  region   = var.region
  size     = "s-1vcpu-1gb"
  image    = "ubuntu-22-04-x64"
  ssh_keys = var.ssh_key_ids
  vpc_uuid = var.vpc_uuid
  tags     = ["vpn", "terraform"]

  connection {
    type        = "ssh"
    user        = "root"
    host        = self.ipv4_address
    private_key = file(var.ssh_private_key_path)
  }

  provisioner "remote-exec" {
  inline = [
    "echo '✅ Starting VPN setup...'",

    # Ensure no package manager lock
    "while fuser /var/lib/dpkg/lock >/dev/null 2>&1; do echo '🔒 Waiting for dpkg lock...'; sleep 10; done",
    "apt-get update -y",
    "while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do echo '🔒 Waiting for dpkg lock...'; sleep 10; done",
    "DEBIAN_FRONTEND=noninteractive apt-get install -y strongswan strongswan-pki libstrongswan-extra-plugins",

    # Allow SSH port in case firewall blocks it
    "ufw allow 22/tcp || true",
    "systemctl enable ssh || true",
    "systemctl restart ssh || true",

    # Write IPsec configuration safely
    "bash -c 'cat > /etc/ipsec.conf <<EOF\nconfig setup\n    charondebug=\"all\"\n\nconn azure\n    auto=start\n    keyexchange=${var.protocol}\n    ike=aes256-sha1-modp1024!\n    esp=aes256-sha1!\n    left=%defaultroute\n    leftid=%any\n    leftsubnet=${var.doiv_range}\n    right=${var.azure_gateway_ip}\n    rightsubnet=${var.Azure_subnet}10.1.0.0/16\n    authby=psk\nEOF'",

    # Write secrets file
    "bash -c 'cat > /etc/ipsec.secrets <<EOF\n%any : PSK \"${var.vpn_psk}\"\nEOF'",

    # Restart strongSwan
    "echo '✅ Restarting strongSwan service'",
    "systemctl enable strongswan-starter || systemctl enable strongswan",
    "systemctl restart strongswan-starter || systemctl restart strongswan",

    "echo '✅ VPN setup completed successfully.'"
  ]
}
}