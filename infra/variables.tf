// CORE
variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "europe-west9"
}

variable "zone" {
  type    = string
  default = "europe-west9-a"
}

// CLOUD SQL
variable "db_name" {
  type    = string
  default = "strapi-db"
}

variable "db_user_name" {
  type    = string
  default = "strapi"
}

// APP ENGINE
variable "service_name" {
  type    = string
  default = "strapi"
}

variable "service_runtime" {
  type    = string
  default = "nodejs16"
}

variable "service_entrypoint_command" {
  type    = string
  default = "npm start"
}

variable "service_src_bucket" {
  type = string
}

variable "service_src_dir" {
  type    = string
  default = "../strapi"
}

variable "service_src_excludes" {
  type    = list(string)
  default = ["node_modules"]
}

# STRAPI
variable "strapi_host" {
  type    = string
  default = "0.0.0.0"
}

variable "strapi_node_env" {
  type    = string
  default = "production"
}

variable "strapi_app_keys" {
  type = string
}

variable "strapi_api_token_salt" {
  type = string
}

variable "strapi_admin_jwt_secret" {
  type = string
}

variable "strapi_jwt_secret" {
  type = string
}

variable "strapi_media_bucket" {
  type = string
}


// REPOSITORY
variable "repository_owner" {
  type = string
}

variable "repository_name" {
  type = string
}

// FRONT
variable "front_bucket" {
  type = string
}
