
resource "azurerm_resource_group" "spoke" {
	name 		= "rg-${var.vnet-name}-${var.region_code}"
	location 	= var.region
}

resource "azurerm_resource_group" "nsg" {
	name 		= "rg-${var.nsg-name}-${var.region_code}"
	location 	= var.region
}

resource "azurerm_virtual_network" "spoke" {
	name 				= "vnet-${var.spoke-name}-${var.region_code}"
	address_space 		= ["${var.vnet-cidr}"]
	location 			= azurerm_resource_group.network.location
	resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_virtual_network_peering" "spoke" {
	name 						= "peer-${var.hub-name}-${var.region_code}"
	resource_group_name 		= azurerm_resource_group.spoke.name
	virtual_network_name 		= azurerm_virtual_network.spoke.name
	remote_virtual_network_id 	= azurerm_virtual_network.hub.id
}

resource "azurerm_subnet" "snet-1" {
	name 					= "snet-${var.snet-1-name}-${var.region_code}"
	resource_group_name 	= azurerm_resource_group.network.name
	virtual_network_name 	= azurerm_virtual_network.network.name
	address_prefixes 		= ["${var.snet1-cidr}"]
}

resource "azurerm_subnet" "snet-2" {
	name 					= "snet-${var.snet-2-name}-${var.region_code}"
	resource_group_name 	= azurerm_resource_group.network.name
	virtual_network_name 	= azurerm_virtual_network.network.name
	address_prefixes 		= ["${var.snet2-cidr}"]
}

resource "azurerm_subnet" "snet-3" {
	name 					= "snet-${var.snet-3-name}-${var.region_code}"
	resource_group_name 	= azurerm_resource_group.network.name
	virtual_network_name 	= azurerm_virtual_network.network.name
	address_prefixes 		= ["${var.snet3-cidr}"]
}

resource "azurerm_subnet" "snet-4" {
	name 					= "snet-${var.snet-4-name}-${var.region_code}"
	resource_group_name 	= azurerm_resource_group.network.name
	virtual_network_name 	= azurerm_virtual_network.network.name
	address_prefixes 		= ["${var.snet4-cidr}"]
	enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_route_table" "udr-1" {
	name 							= "udr-${var.udr1-name}-${var.region_code}"
	location 						= azurerm_resource_group.network.location
	resource_group_name 			= azurerm_resource_group.network.name
	disable_bgp_route_propagation 	= true

	route {
		name 			= "default-gateway"
		address_prefix 	= "0.0.0.0/0"
		next_hop_type 	= "Internet"
	}
}

resource "azurerm_subnet_route_table_association" "snet-1" {
	subnet_id 		= azurerm_subnet.snet-1.id
	route_table_id	= azurerm_route_table.udr-1.id
}

resource "azurerm_subnet_route_table_association" "snet-2" {
	subnet_id 		= azurerm_subnet.snet-2.id
	route_table_id	= azurerm_route_table.udr-1.id
}

resource "azurerm_subnet_route_table_association" "snet-3" {
	subnet_id 		= azurerm_subnet.snet-3.id
	route_table_id	= azurerm_route_table.udr-1.id
}

resource "azurerm_network_security_group" "nsg-1" {
	name 					= "udr-${var.nsg1-name}-${var.region_code}"
	resource_group_name 	= azurerm_resource_group.nsg.name
	location 				= azurerm_resource_group.network.location
}

resource "azurerm_network_security_rule" "rule-1" {
	name 						= "nsg-1"
	priority 					= 110
	direction 					= "Inbound"
	access 						= "Allow"
	protocol 					= "Tcp"
	source_port_range 			= "*"
	destination_port_range 		= "22"
	source_address_prefix 		= "*"
	destination_address_prefix 	= "*"
	resource_group_name 		= azurerm_resource_group.nsg.name
	network_security_group_name	= azurerm_network_security_group.nsg-1.name
	}

resource "azurerm_subnet_network_security_group_association" "snet-1" {
	subnet_id					= azurerm_subnet.snet-1.id
	network_security_group_id	= azurerm_network_security_group.nsg-1.id
}

resource "azurerm_subnet_network_security_group_association" "snet-2" {
	subnet_id					= azurerm_subnet.snet-2.id
	network_security_group_id	= azurerm_network_security_group.nsg-1.id
}

resource "azurerm_subnet_network_security_group_association" "snet-3" {
	subnet_id					= azurerm_subnet.snet-3.id
	network_security_group_id	= azurerm_network_security_group.nsg-1.id
}
