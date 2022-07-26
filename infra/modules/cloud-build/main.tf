resource "random_password" "cloudbuild_secret" {
  length           = 16
  special          = true
  override_special = "_"
}

resource "google_secret_manager_secret" "secret" {
  secret_id = var.cloud_build_webhook_secret

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "secret_version_latest" {
  secret      = google_secret_manager_secret.secret.id
  secret_data = random_password.cloudbuild_secret.result
}

data "google_project" "project" {}

data "google_iam_policy" "secret_accessor" {
  binding {
    role = "roles/secretmanager.secretAccessor"
    members = [
      "serviceAccount:service-${data.google_project.project.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com",
    ]
  }
}

resource "google_secret_manager_secret_iam_policy" "policy" {
  secret_id   = google_secret_manager_secret.secret.secret_id
  policy_data = data.google_iam_policy.secret_accessor.policy_data
}


resource "google_cloudbuild_trigger" "webhook_trigger" {
  name = "webhook-trigger"

  webhook_config {
    secret = google_secret_manager_secret_version.secret_version_latest.id
  }

  source_to_build {
    uri       = format("https://github.com/%s/%s", var.repository_owner, var.repository_name)
    ref       = "refs/heads/main"
    repo_type = "GITHUB"
  }

  git_file_source {
    uri       = format("https://github.com/%s/%s", var.repository_owner, var.repository_name)
    revision  = "refs/heads/main"
    repo_type = "GITHUB"
    path      = "cloudbuild.yaml"
  }

  substitutions = var.substitutions
}

resource "google_cloudbuild_trigger" "push_trigger" {
  name     = "push-trigger"
  filename = "cloudbuild.yaml"

  github {
    owner = var.repository_owner
    name  = var.repository_name
    push {
      branch = "^main$"
    }
  }

  included_files = ["front/**"]
  substitutions  = var.substitutions
}
