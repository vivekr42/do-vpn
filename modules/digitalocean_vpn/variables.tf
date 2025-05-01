variable "region" {
  description = "DigitalOcean region for the droplet"
  type        = string
}

variable "droplet_name" {
  description = "Name of the VPN droplet"
  type        = string
}

variable "vpc_uuid" {
  description = "Optional VPC UUID to launch the droplet into"
  type        = string
  default     = null
}

variable "ssh_key_ids" {
  description = "List of SSH key IDs to access the droplet"
  type        = list(string)
}

variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
}

variable "vpn_psk" {
  description = "Pre-shared key for IPSec VPN"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to the private key for SSH provisioning"
  type        = string
}

variable "azure_gateway_ip" {
  description = "Azure VPN Gateway Public IP"
  type        = string
}
