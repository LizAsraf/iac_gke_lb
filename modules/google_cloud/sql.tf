resource "google_sql_database_instance" "sql_instance" {
  name = "sql-instance"
  database_version = "POSTGRES_14"
  region = var.region
  root_password = var.db_root_password
  project = var.project_id
  settings {
    tier = "db-custom-2-13312"
    activation_policy = "ALWAYS"
    ip_configuration {
      private_network = var.google_compute_network_id
    }
  }
  deletion_protection  = "false"
}

resource "google_sql_database" "my_db" {
  name = var.database
  instance = google_sql_database_instance.sql_instance.name
}

resource "google_sql_user" "my_user" {
  name = var.username
  instance = google_sql_database_instance.sql_instance.name
  password = var.password
}