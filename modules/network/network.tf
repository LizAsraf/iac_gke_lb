data "google_compute_network" "default_vpc" {
  name = "default"
}
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
resource "google_compute_subnetwork" "private" {
  name                     = "private"
  project                  = var.project_id
  ip_cidr_range            = "10.5.0.0/20"
  region                   = var.region
  network                  = data.google_compute_network.default_vpc.self_link
  private_ip_google_access = true
}

resource "google_compute_global_address" "ip_address" {
  name = "google-managed-services-default"
  purpose="VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length=16
  description = "peering range for Google"
  network = data.google_compute_network.default_vpc.name
  /* subnetwork = google_compute_subnetwork.private.name */
}

resource "google_service_networking_connection" "private_vpc_connection" {
  service = "servicenetworking.googleapis.com"
  network = "default"
  reserved_peering_ranges = [google_compute_global_address.ip_address.name]
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router
resource "google_compute_router" "router" {
  name    = "router"
  region  = var.region
  project = var.project_id
  network = data.google_compute_network.default_vpc.self_link
}

resource "google_compute_router_nat" "mist_nat" {
  depends_on = [google_compute_subnetwork.private]
  name                               = "nat"
  project                            = var.project_id
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
