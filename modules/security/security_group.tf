data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service
data "google_project" "k8s-staging" {
  project_id = var.project_id
}
resource "google_project_service" "host" {
  project = var.project_id
  service = "container.googleapis.com"
}

resource "google_project_iam_member" "gke_service_account" {
  project = var.project_id
  role = "roles/cloudsql.client"
  member = "serviceAccount:${google_service_account.k8s-staging.email}"
}

resource "google_project_iam_member" "gke_log_writer" {
  project = var.project_id
  role = "roles/logging.logWriter"
  member = "serviceAccount:${google_service_account.k8s-staging.email}"
}

resource "google_project_iam_member" "storage_viewer" {
  project = var.project_id
  role = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.k8s-staging.email}"
}

resource "google_project_iam_member" "artifact_reader" {
  project = var.project_id
  role = "roles/artifactregistry.reader"
  member = "serviceAccount:${google_service_account.k8s-staging.email}"
}

resource "google_service_account_key" "k8s-staging_key" {
  service_account_id = google_service_account.k8s-staging.name
}

resource "google_service_account" "k8s-staging" {
  project    = var.project_id
  account_id = "k8s-staging"
  display_name = "k8s-staging"
}