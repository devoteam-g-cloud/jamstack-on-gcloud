resource "google_storage_bucket" "bucket" {
  location                    = var.bucket_location
  name                        = var.bucket_name
  storage_class               = var.storage_class
  uniform_bucket_level_access = var.uniform_level_access

  dynamic "website" {
    for_each = var.website_index != null && var.website_not_found != null ? [1] : []
    content {
      main_page_suffix = var.website_index
      not_found_page   = var.website_not_found
    }
  }
}

resource "google_storage_default_object_access_control" "bucket_acl" {
  for_each = var.acl
  bucket   = google_storage_bucket.bucket.name
  entity   = each.key
  role     = each.value
}
