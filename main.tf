# module "canadacentral" {
#     source              = "./cac"
#     region              = "canadacentral"
#     region_code         = "cac"
#     hub-name            = "hub"
#     spoke-name          = "spoke"
#     rg-vnet-hub-name    = "hub"
#     rg-vnet-spoke-name  = "spoke"
#     hub-cidr            = "10.0.0.0/16"
#     spoke-cidr          = "10.1.0.0/16"
#     nsg-name            = "nsg"
#     snet-1-name         = "one"
#     snet1-cidr          = "10.1.1.0/24"
#     snet-2-name         = "two"
#     snet2-cidr          = "10.1.2.0/24"
#     snet-3-name         = "three"
#     snet3-cidr          = "10.1.3.0/24"
#     snet-4-name         = "PrivateEndpoint"
#     snet4-cidr          = "10.1.4.0/24"
#     udr1-name           = "one"
#     nsg1-name           = "one"
# }

# module "canadaeast" {
#     source          = "./cae"
#     region          = "canadaeast"
#     region_code     = "cae"
#     vnet-name       = "network"
#     network-name    = "one"
#     vnet-cidr       = "10.1.0.0/16"
#     nsg-name        = "nsg"
#     snet-1-name     = "one"
#     snet1-cidr      = "10.1.1.0/24"
#     snet-2-name     = "two"
#     snet2-cidr      = "10.1.2.0/24"
#     snet-3-name     = "three"
#     snet3-cidr      = "10.1.3.0/24"
#     snet-4-name     = "PrivateEndpoint"
#     snet4-cidr      = "10.1.4.0/24"
#     udr1-name       = "one"
#     nsg1-name       = "one"
# }