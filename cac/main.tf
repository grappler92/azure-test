
resource "azurerm_resource_group" "hub" {
	name 		= "rg-${var.rg-vnet-hub-name}-${var.region_code}"
	location 	= var.region
}

module "vnet-hub" {
	source 				= "Azure/vnet/azurerm"
	resource_group_name	= azurerm_resource_group.hub.name
    vnet_name           = "vnet-${var.hub-name}-${var.region_code}"
	address_space		= ["10.0.0.0/16"]
	subnet_prefixes		= ["10.0.1.0/24"]
	subnet_names		= ["GatewaySubnet"]

	# subnet_service_endpoints = {
	# 	subnet2	= []
	# 	subnet3	= []
	# }

	depends_on = [azurerm_resource_group.hub]	
}

#######################################################################


resource "azurerm_resource_group" "spoke" {
	name 		= "rg-${var.rg-vnet-spoke-name}-${var.region_code}"
	location 	= var.region
}

# module "vnet-spoke" {
# 	source 				= "Azure/vnet/azurerm"
#     version             = "2.5.0"
# 	resource_group_name	= azurerm_resource_group.spoke.name
#     vnet_name           = "vnet-${var.spoke-name}-${var.region_code}"
# 	address_space		= ["10.1.0.0/16"]
# 	subnet_prefixes		= ["10.1.1.0/24","10.1.2.0/24","10.1.3.0/24","10.1.4.0/24"]
# 	subnet_names		= ["presentation","application","database","privateendpoint"]

# 	depends_on = [azurerm_resource_group.spoke]	
# }

# resource "azurerm_route_table" "udr-1" {
# 	name 							= "udr-${var.udr1-name}-${var.region_code}"
# 	location 						= azurerm_resource_group.spoke.location
# 	resource_group_name 			= azurerm_resource_group.spoke.name
# 	disable_bgp_route_propagation 	= true

# 	route {
# 		name 			= "default-gateway"
# 		address_prefix 	= "0.0.0.0/0"
# 		next_hop_type 	= "Internet"
# 	}
# }

resource "azurerm_resource_group" "udr-spoke" {
	name 		= "rg-${var.rg-udr-spoke-name}-${var.region_code}"
	location 	= var.region
}

module "udr-spoke" {
    source              = "Azure/routetable/azurerm"
    version             = "1.0.0"
    resource_group_name = azurerm_resource_group.udr-spoke.name
    location            = azurerm_resource_group.udr-spoke.location
    route_table_name    = "udr-${var.rg-udr-spoke-name}-${var.region_code}"
    route_prefixes      = ["0.0.0.0/0"]
    route_nexthop_types = ["Internet"]
    route_names         = ["default-route"]

    tags = {
        environment = "test"
        costcenter  = "1111"
    }
}

resource "azurerm_resource_group" "nsg-rg" {
	name 		= "rg-${var.nsg-name}-${var.region_code}"
	location 	= var.region
}

module "network-security-group" {
	source 		            = "Azure/network-security-group/azurerm"
    version                 = "3.6.0"
	resource_group_name 	= azurerm_resource_group.nsg-rg.name
	security_group_name		= "nsg-test-cac"
	custom_rules = [
		{
		name 					= "my-test"
		priority 				= "200"
		direction				= "Inbound"
		access					= "Allow"
		protocol				= "tcp"
		source_port_range 		= "*"
		destination_port_range	= "443"
		source_address_prefixes	= ["10.2.0.0/24"]
		description				= "my test nsg using public module"
	},
	]

	depends_on = [azurerm_resource_group.nsg-rg]
}	

#######################################################################

# module "vnet-peering" {
#     source                  = "Azure/vnetpeering/azurerm"
#     vnet_peering_names      = ["peer2spoke", "peer2hub"]
#     vnet_names              = [module.vnet-hub.vnet_name, module.vnet-spoke.vnet_name]
#     resource_group_names    = [azurerm_resource_group.hub.name, azurerm_resource_group.spoke.name]
# }
