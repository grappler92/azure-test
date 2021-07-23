
resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
  description             = "Network Services VPC"
  project                 = var.vproject  
}

resource "google_compute_subnetwork" "transport" {
  name            = var.snet_transport_name_nane
  ip_cidr_range   = var.addr_transport_range_nane
  network         = google_compute_network.vpc.self_link
  region          = var.region1
  description     = "Transport Subnet northamerica-northeast"
}

