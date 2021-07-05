
resource "azurerm_resource_group" "network" {
	name 		= "rg-network"
	location 	= "canadacentral"
}

resource "azurerm_resource_group" "nsg" {
	name 		= "rg-nsg"
	location 	= "canadacentral"
}

resource "azurerm_virtual_network" "network" {
	name 				= "production-network"
	address_space 		= ["10.0.0.0/16"]
	location 			= azurerm_resource_group.network.location
	resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_subnet" "snet-1" {
	name 					= "subnet-1"
	resource_group_name 	= azurerm_resource_group.network.name
	virtual_network_name 	= azurerm_virtual_network.network.name
	address_prefixes 		= ["10.0.1.0/24"]
}

resource "azurerm_subnet" "snet-2" {
	name 					= "subnet-2"
	resource_group_name 	= azurerm_resource_group.network.name
	virtual_network_name 	= azurerm_virtual_network.network.name
	address_prefixes 		= ["10.0.2.0/24"]
}

resource "azurerm_subnet" "snet-3" {
	name 					= "subnet-3"
	resource_group_name 	= azurerm_resource_group.network.name
	virtual_network_name 	= azurerm_virtual_network.network.name
	address_prefixes 		= ["10.0.3.0/24"]
}

resource "azurerm_network_security_group" "nsg-1" {
	name 					= "nsg-1"
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
