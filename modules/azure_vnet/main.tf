terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_resource_group" "vpn_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vpn_vnet" {
  name                = "vpn-vnet"
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.vpn_rg.name
}

resource "azurerm_subnet" "gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.vpn_rg.name
  virtual_network_name = azurerm_virtual_network.vpn_vnet.name
  address_prefixes     = [var.subnet_prefix]
}

resource "azurerm_public_ip" "vpn_gateway_ip" {
  name                = "vpn-gateway-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.vpn_rg.name
  allocation_method   = "Static"
  sku = "Standard" 
}

resource "azurerm_virtual_network_gateway" "vpn_gateway" {
  name                = "vpn-gateway"
  location            = var.location
  resource_group_name = azurerm_resource_group.vpn_rg.name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  active_active       = false
  enable_bgp          = false
  sku                 = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn_gateway_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway_subnet.id
  }
}

resource "azurerm_local_network_gateway" "do_local_gateway" {
  name                = "do-local-gateway"
  location            = var.location
  resource_group_name = azurerm_resource_group.vpn_rg.name
  gateway_address     = var.do_public_ip
  address_space       = [var.do_address_space]
}

resource "azurerm_virtual_network_gateway_connection" "vpn_connection" {
  name                            = "vpn-connection"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.vpn_gateway.id
  local_network_gateway_id        = azurerm_local_network_gateway.do_local_gateway.id
  type                 = "IPsec"
  shared_key                      = var.shared_key
}