variable "global_ip_name" {
  type    = string
  default = "static-website-ip"
}

variable "bucket_backend_name" {
  type    = string
  default = "static-website-backend"
}

variable "bucket_name" {
  type = string
}

variable "ssl_certificate_name" {
  type    = string
  default = "static-website-tls"
}

variable "load_balancer_name" {
  type    = string
  default = "static-website-lb"
}

variable "https_proxy_name" {
  type    = string
  default = "static-website-https-proxy"
}

variable "forwarding_rule_name" {
  type    = string
  default = "static-website-forwarding-rule"
}
