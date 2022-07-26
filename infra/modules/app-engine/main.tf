resource "google_app_engine_standard_app_version" "app_version" {
  service    = var.service_name
  runtime    = var.service_runtime
  version_id = var.service_version_id

  entrypoint {
    shell = var.service_entrypoint_command
  }

  deployment {
    zip {
      source_url = "https://storage.googleapis.com/${var.service_src_bucket}/${google_storage_bucket_object.object.name}"
    }
  }

  env_variables = var.service_env_vars

  delete_service_on_destroy = true
}

resource "google_storage_bucket_object" "object" {
  name   = "${data.archive_file.archive.output_md5}.zip"
  bucket = var.service_src_bucket
  source = data.archive_file.archive.output_path
}

data "archive_file" "archive" {
  type        = "zip"
  source_dir  = var.service_src_dir
  output_path = "archive.zip"
  excludes    = var.service_src_excludes
}
