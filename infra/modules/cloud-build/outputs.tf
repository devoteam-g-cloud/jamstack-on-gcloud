output "db_password" {
  value = random_password.cloudbuild_secret.result
}
