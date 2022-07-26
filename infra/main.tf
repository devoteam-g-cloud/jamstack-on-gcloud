locals {
  api_url   = var.service_name == "default" ? "https://${var.project_id}.appspot.com/graphql" : "https://${var.service_name}-dot-${var.project_id}.appspot.com/graphql"
  admin_url = var.service_name == "default" ? "https://${var.project_id}.appspot.com/admin" : "https://${var.service_name}-dot-${var.project_id}.appspot.com/admin"
}

data "google_project" "project" {}

module "database" {
  source = "./modules/cloud-sql"

  db_name      = var.db_name
  db_user_name = var.db_user_name
}

module "appengine_bucket" {
  source = "./modules/cloud-storage"

  bucket_name = var.service_src_bucket
}

module "strapi_media_bucket" {
  source = "./modules/cloud-storage"

  bucket_name = var.strapi_media_bucket
  acl = tomap({
    "allUsers" = "READER"
  })
}

module "front_bucket" {
  source = "./modules/cloud-storage"

  bucket_name = var.front_bucket
  acl = tomap({
    "allUsers"                                                                                     = "READER",
    "user-service-${data.google_project.project.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com" = "OWNER"
  })

  website_index     = "index.html"
  website_not_found = "404.html"
}

module "strapi" {
  source = "./modules/app-engine"

  service_name               = var.service_name
  service_runtime            = var.service_runtime
  service_entrypoint_command = var.service_entrypoint_command
  service_src_bucket         = module.appengine_bucket.bucket_name
  service_src_dir            = var.service_src_dir
  service_src_excludes       = var.service_src_excludes
  service_env_vars = {
    HOST                     = var.strapi_host,
    NODE_ENV                 = var.strapi_node_env,
    APP_KEYS                 = var.strapi_app_keys,
    API_TOKEN_SALT           = var.strapi_api_token_salt
    ADMIN_JWT_SECRET         = var.strapi_admin_jwt_secret,
    JWT_SECRET               = var.strapi_jwt_secret
    DATABASE_NAME            = var.db_name,
    DATABASE_USER            = var.db_user_name,
    DATABASE_PASSWORD        = module.database.db_password,
    INSTANCE_CONNECTION_NAME = module.database.db_connection_name,
    GCS_BUCKET_NAME          = module.strapi_media_bucket.bucket_name
  }
}

module "cloud_build" {
  source = "./modules/cloud-build"

  repository_owner = var.repository_owner
  repository_name  = var.repository_name
  substitutions = {
    _FRONT_BUCKET_NAME = module.front_bucket.bucket_name,
    _API_URL           = local.api_url
  }
}

module "global_cdn" {
  source = "./modules/cloud-cdn"

  bucket_name = module.front_bucket.bucket_name
}
