output "vpn_droplet_ip" {
  description = "Public IP of the VPN droplet"
  value       = digitalocean_droplet.vpn.ipv4_address
}