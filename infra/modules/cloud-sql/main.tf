resource "google_sql_database_instance" "instance" {
  name             = var.db_name
  database_version = var.db_version

  deletion_protection = true

  settings {
    tier              = var.db_tier
    availability_type = var.availability_type
    disk_autoresize   = var.disk_autoresize
    disk_size         = var.disk_size
    disk_type         = var.disk_type

    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
      start_time                     = "07:00"
      transaction_log_retention_days = 7

      backup_retention_settings {
        retained_backups = 7
        retention_unit   = "COUNT"
      }
    }

    ip_configuration {
      ipv4_enabled = true
    }
  }
}

resource "google_sql_database" "database" {
  name     = var.db_name
  instance = google_sql_database_instance.instance.name
}

resource "random_password" "postgres_password" {
  length           = 16
  special          = true
  override_special = "_"
}

resource "google_sql_user" "postgres_user" {
  name     = var.db_user_name
  instance = google_sql_database_instance.instance.name
  password = random_password.postgres_password.result
}

resource "google_secret_manager_secret" "secret" {
  secret_id = var.db_password_secret

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "secret_version_latest" {
  secret      = google_secret_manager_secret.secret.id
  secret_data = random_password.postgres_password.result
}
