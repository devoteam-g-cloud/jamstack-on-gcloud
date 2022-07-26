output "db_password" {
  value = random_password.postgres_password.result
}

output "db_connection_name" {
  value       = google_sql_database_instance.instance.connection_name
  description = "db connection name"
}
