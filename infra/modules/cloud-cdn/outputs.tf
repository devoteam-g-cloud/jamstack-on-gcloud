output "front_url" {
  value = google_compute_managed_ssl_certificate.ssl_certificate.managed[0].domains[0]
}
