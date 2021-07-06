
resource "azurerm_resource_group" "hub" {
	name 		= "rg-${var.rg-vnet-hub-name}-${var.region_code}"
	location 	= var.region
}

resource "azurerm_virtual_network" "hub" {
	name 				= "vnet-${var.hub-name}-${var.region_code}"
	address_space 		= ["${var.hub-cidr}"]
	location 			= azurerm_resource_group.hub.location
	resource_group_name = azurerm_resource_group.hub.name
}

resource "azurerm_subnet" "gateway" {
	name 					= "snet-${var.snet-gw-name}-${var.region_code}"
	resource_group_name 	= azurerm_resource_group.hub.name
	virtual_network_name 	= azurerm_virtual_network.hub.name
	address_prefixes 		= ["${var.snet-gw-cidr}"]
}

# resource "azurerm_virtual_network_peering" "hub" {
# 	name 						= "peer-${var.spoke-name}-${var.region_code}"
# 	resource_group_name 		= azurerm_resource_group.hub.name
# 	virtual_network_name 		= azurerm_virtual_network.hub.name
# 	remote_virtual_network_id 	= azurerm_virtual_network.spoke.id
# }