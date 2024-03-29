
resource "azurerm_resource_group" "network" {
	name 		= var.rg-network-name
	location 	= var.region
}

resource "azurerm_resource_group" "nsg" {
	name 		= var.rg-nsg-name
	location 	= var.region
}

resource "azurerm_virtual_network" "network" {
	name 				= var.vnet-name
	address_space 		= ["10.0.0.0/16"]
	location 			= azurerm_resource_group.network.location
	resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_subnet" "snet-1" {
	name 					= var.snet-1-name
	resource_group_name 	= azurerm_resource_group.network.name
	virtual_network_name 	= azurerm_virtual_network.network.name
	address_prefixes 		= ["10.0.1.0/24"]
}

resource "azurerm_subnet" "snet-2" {
	name 					= var.snet-2-name
	resource_group_name 	= azurerm_resource_group.network.name
	virtual_network_name 	= azurerm_virtual_network.network.name
	address_prefixes 		= ["10.0.2.0/24"]
}

resource "azurerm_subnet" "snet-3" {
	name 					= var.snet-3-name
	resource_group_name 	= azurerm_resource_group.network.name
	virtual_network_name 	= azurerm_virtual_network.network.name
	address_prefixes 		= ["10.0.3.0/24"]
}

resource "azurerm_subnet" "snet-4" {
	name 					= var.snet-4-name
	resource_group_name 	= azurerm_resource_group.network.name
	virtual_network_name 	= azurerm_virtual_network.network.name
	address_prefixes 		= ["10.0.4.0/24"]
	enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_route_table" "udr-1" {
	name 							= var.udr1-name
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
	name 					= var.nsg1-name
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
