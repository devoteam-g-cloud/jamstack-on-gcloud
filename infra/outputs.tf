output "strapi_url" {
  value = local.admin_url
}

output "front_url" {
  value = module.global_cdn.front_url
}
