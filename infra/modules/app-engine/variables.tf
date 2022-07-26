variable "service_name" {
  type = string
}

variable "service_runtime" {
  type = string
}

variable "service_entrypoint_command" {
  type = string
}

variable "service_env_vars" {
  type = map(any)
}

variable "service_src_bucket" {
  type = string
}

variable "service_src_dir" {
  type = string
}

variable "service_src_excludes" {
  type = list(string)
}

variable "service_version_id" {
  type    = string
  default = "v1"
}
