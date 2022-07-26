variable "repository_owner" {
  type = string
}

variable "repository_name" {
  type = string
}

variable "substitutions" {
  type = map(string)
}

variable "cloud_build_webhook_secret" {
  type    = string
  default = "cloudbuild-webhook-secret"
}
