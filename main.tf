module "network" {
  source = "./modules/network"
  project_id = var.project_id
  region = var.region
}

module "security" {
  source = "./modules/security"
  project_id = var.project_id
}

module "compute" {
  source = "./modules/compute"
  depends_on = [module.gke, module.security]
  project_id = var.project_id
  region = var.region
  google_service_account = module.security.google_service_account
  google_container_cluster = module.gke.google_container_cluster
  instance_type = var.instance_type
}

module "gke" {
  source = "./modules/gke"
  depends_on = [module.network]
  project_id = var.project_id
  region = var.region
  pods_ipv4_cidr_block = var.pods_ipv4_cidr_block
  services_ipv4_cidr_block = var.services_ipv4_cidr_block
  google_compute_network = module.network.google_compute_network
  google_compute_subnetwork = module.network.google_compute_subnetwork
}

module "google_cloud" {
  source = "./modules/google_cloud"
  depends_on = [module.network]
  project_id = var.project_id
  region = var.region
  db_root_password = var.db_root_password
  google_compute_network_id = module.network.google_compute_network_id
  database = var.database
  username = var.username
  password = var.password
}