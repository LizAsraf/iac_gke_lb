resource "google_container_node_pool" "general" {
  provider = google-beta

  name       = var.google_container_cluster
  location   = var.region
  cluster    = var.google_container_cluster
  project    = var.project_id
  node_count = 1

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    labels = {
      role = "general", 
      env = var.project_id
    }
    tags         = ["gke-node", "${var.project_id}-gke"]
    machine_type = var.instance_type

    service_account = var.google_service_account
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
    ]
  }
}

resource "null_resource" "file" {
  depends_on = [google_container_node_pool.general]
  provisioner "local-exec" {
    command = "./commands.sh"
  }
}