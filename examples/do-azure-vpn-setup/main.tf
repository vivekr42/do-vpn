module "azure_vnet" {
  source              = "../../modules/azure_vnet"
  vnet_address_space  = var.azure_address_space
  subnet_prefix       = var.azure_subnet_prefix
  do_public_ip        = module.do_vpn.vpn_droplet_ip  
  do_address_space    = var.do_address_space
  shared_key          = var.vpn_psk
  resource_group_name = var.azure_resource_group
  location            = var.azure_location
}


module "do_vpn" {
  source                = "../../modules/digitalocean_vpn"
  do_token              = var.do_token
  ssh_key_ids           = var.ssh_key_ids
  ssh_private_key_path  = var.ssh_private_key_path
  droplet_name          = var.droplet_name
  vpn_psk               = var.vpn_psk
  azure_gateway_ip = module.azure_vnet.vpn_gateway_public_ip
  region                = var.region
}

