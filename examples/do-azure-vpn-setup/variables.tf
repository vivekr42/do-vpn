variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
}

variable "ssh_key_ids" {
  description = "List of SSH key fingerprints or IDs registered in DO"
  type        = list(string)
}

variable "ssh_private_key_path" {
  description = "Path to the private SSH key to connect to DO droplet"
  type        = string
}

variable "droplet_name" {
  description = "Name of the DigitalOcean droplet"
  type        = string
}

variable "vpn_psk" {
  description = "Pre-shared key used for VPN"
  type        = string
}

variable "azure_gateway_ip" {
  description = "Public IP of the Azure VPN Gateway"
  type        = string
}

variable "region" {
  description = "DigitalOcean region for the droplet"
  type        = string
}

variable "azure_location" {
  description = "Azure region for VNet deployment"
  type        = string
}

variable "azure_resource_group" {
  description = "Azure resource group name"
  type        = string
}

variable "azure_address_space" {
  description = "Azure VNet address space"
  type        = list(string)
}
variable "azure_subnet_prefix" {
  description = "Azure subnet CIDR block"
  type        = string
}



variable "do_address_space" {
  description = "CIDR block used on DigitalOcean side of the VPN"
  type        = string
}
variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "azure_client_id" {
  description = "Azure client/application ID"
  type        = string
}

variable "azure_client_secret" {
  description = "Azure client secret"
  type        = string
  sensitive   = true
}

variable "azure_tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "doiv_range" {
  description = "Local subnet (DigitalOcean internal VPC range)"
  type        = string
  default     = "10.10.0.0/24"
}

variable "Azure_subnet" {
  description = "The subnet on the Azure side"
  type        = string
  default     = "10.1.0.0/16"
}

variable "protocol" {
  description = "Modern and secure protocol"
  type        = string
  default     = "ikev2"
}

