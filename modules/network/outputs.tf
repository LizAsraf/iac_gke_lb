output "google_compute_network" {
  value = data.google_compute_network.default_vpc.self_link
}

output "google_compute_subnetwork" {
  value = google_compute_subnetwork.private.self_link
}

output "google_compute_network_id" {
  value = data.google_compute_network.default_vpc.id
}