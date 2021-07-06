
resource "azurerm_resource_group" "spoke" {
	name 		= "rg-${var.rg-vnet-spoke-name}-${var.region_code}"
	location 	= var.region
}

resource "azurerm_virtual_network" "spoke" {
	name 				= "vnet-${var.spoke-name}-${var.region_code}"
	address_space 		= ["${var.spoke-cidr}"]
	location 			= azurerm_resource_group.spoke.location
	resource_group_name = azurerm_resource_group.spoke.name
}

resource "azurerm_virtual_network_peering" "spoke" {
	name 						= "peer-${var.hub-name}-${var.region_code}"
	resource_group_name 		= azurerm_resource_group.spoke.name
	virtual_network_name 		= azurerm_virtual_network.spoke.name
	remote_virtual_network_id 	= azurerm_virtual_network.hub.id
}

resource "azurerm_subnet" "presentation" {
	name 					= "snet-${var.snet-pres-name}-${var.region_code}"
	resource_group_name 	= azurerm_resource_group.spoke.name
	virtual_network_name 	= azurerm_virtual_network.spoke.name
	address_prefixes 		= ["${var.snet1-cidr}"]
}

resource "azurerm_subnet" "application" {
	name 					= "snet-${var.snet-app-name}-${var.region_code}"
	resource_group_name 	= azurerm_resource_group.spoke.name
	virtual_network_name 	= azurerm_virtual_network.spoke.name
	address_prefixes 		= ["${var.snet2-cidr}"]
}

resource "azurerm_subnet" "database" {
	name 					= "snet-${var.snet-db-name}-${var.region_code}"
	resource_group_name 	= azurerm_resource_group.spoke.name
	virtual_network_name 	= azurerm_virtual_network.spoke.name
	address_prefixes 		= ["${var.snet3-cidr}"]
}

resource "azurerm_subnet" "privateendpoint" {
	name 					= "snet-${var.snet-4-name}-${var.region_code}"
	resource_group_name 	= azurerm_resource_group.spoke.name
	virtual_network_name 	= azurerm_virtual_network.spoke.name
	address_prefixes 		= ["${var.snet4-cidr}"]
	enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_route_table" "udr-1" {
	name 							= "udr-${var.udr1-name}-${var.region_code}"
	location 						= azurerm_resource_group.spoke.location
	resource_group_name 			= azurerm_resource_group.spoke.name
	disable_bgp_route_propagation 	= true

	route {
		name 			= "default-gateway"
		address_prefix 	= "0.0.0.0/0"
		next_hop_type 	= "Internet"
	}
}

resource "azurerm_subnet_route_table_association" "presentation" {
	subnet_id 		= azurerm_subnet.presentation.id
	route_table_id	= azurerm_route_table.udr-1.id
}

resource "azurerm_subnet_route_table_association" "application" {
	subnet_id 		= azurerm_subnet.application.id
	route_table_id	= azurerm_route_table.udr-1.id
}

resource "azurerm_subnet_route_table_association" "database" {
	subnet_id 		= azurerm_subnet.database.id
	route_table_id	= azurerm_route_table.udr-1.id
}

# resource "azurerm_resource_group" "nsg" {
# 	name 		= "rg-${var.nsg-name}-${var.region_code}"
# 	location 	= var.region
# }

# resource "azurerm_network_security_group" "nsg-1" {
# 	name 					= "udr-${var.nsg1-name}-${var.region_code}"
# 	resource_group_name 	= azurerm_resource_group.nsg.name
# 	location 				= azurerm_resource_group.spoke.location
# }

# resource "azurerm_network_security_rule" "rule-1" {
# 	name 						= "nsg-1"
# 	priority 					= 110
# 	direction 					= "Inbound"
# 	access 						= "Allow"
# 	protocol 					= "Tcp"
# 	source_port_range 			= "*"
# 	destination_port_range 		= "22"
# 	source_address_prefix 		= "*"
# 	destination_address_prefix 	= "*"
# 	resource_group_name 		= azurerm_resource_group.nsg.name
# 	network_security_group_name	= azurerm_network_security_group.nsg-1.name
# 	}

# resource "azurerm_subnet_network_security_group_association" "snet-1" {
# 	subnet_id					= azurerm_subnet.snet-1.id
# 	network_security_group_id	= azurerm_network_security_group.nsg-1.id
# }

# resource "azurerm_subnet_network_security_group_association" "snet-2" {
# 	subnet_id					= azurerm_subnet.snet-2.id
# 	network_security_group_id	= azurerm_network_security_group.nsg-1.id
# }

# resource "azurerm_subnet_network_security_group_association" "snet-3" {
# 	subnet_id					= azurerm_subnet.snet-3.id
# 	network_security_group_id	= azurerm_network_security_group.nsg-1.id
# }

module "nsg-test" {
	source 	= "app.terraform.io/grappler92/nsg/azurerm"
	version = "0.0.6"                                                      ## Mandatory , please use the most current version
 	rg-nsg-name	= "rg-test"
	location	= "canadacentral"
	 rules = {
    	test-rule-1 = {                                       ## Mandatory Name of the Firewall Rule
      	name          		= "test01"     ## Mandatory Description of FW Rule
      	direction            	= "Inbound"                                  ## Mandatory Direction INGRESS | EGRESS 
      	access               	= "Allow"                                    ## Mandatory Allow | Deny
     	ip_ranges            	= ["10.2.0.0/24"]                         ## Mandatory list variable to be used as source IP when Direction = INGRESS or destination IP when Direction = EGRESS
	  	sources				= null
      	service = [                                                       ## Mandatory services List
        	{
          		protocol 				= "Tcp"       ### String Var
          		destination_port_range  = ["443"]     ### List Var
        	}
      	]
    extra_attributes = {    ### Optional list variable to set priority or any future addtion to the format 
        priority = "110"     ### required (default value is 1000)
        }
    }
  }
}	
