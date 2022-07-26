# Reserve an external IP
resource "google_compute_global_address" "global_ip" {
  name = var.global_ip_name
}

# Add the bucket as a CDN backend
resource "google_compute_backend_bucket" "backend_bucket" {
  name        = var.bucket_backend_name
  bucket_name = var.bucket_name
  enable_cdn  = true
}

# Create HTTPS certificate
resource "google_compute_managed_ssl_certificate" "ssl_certificate" {
  name = var.ssl_certificate_name
  managed {
    domains = [
      format("%s.nip.io", replace(google_compute_global_address.global_ip.address, ".", "-"))
    ]
  }
}

# GCP URL MAP
resource "google_compute_url_map" "load_balancer" {
  name            = var.load_balancer_name
  default_service = google_compute_backend_bucket.backend_bucket.self_link
}

# GCP target proxy
resource "google_compute_target_https_proxy" "https_proxy" {
  name             = var.https_proxy_name
  url_map          = google_compute_url_map.load_balancer.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.ssl_certificate.self_link]
}

# GCP forwarding rule
resource "google_compute_global_forwarding_rule" "forwarding_rule" {
  name                  = var.forwarding_rule_name
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.global_ip.address
  ip_protocol           = "TCP"
  port_range            = "443"
  target                = google_compute_target_https_proxy.https_proxy.self_link
}
