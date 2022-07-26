variable "bucket_name" {
  type = string
}

variable "bucket_location" {
  type    = string
  default = "europe-west9"
}

variable "storage_class" {
  type    = string
  default = "STANDARD"
}

variable "uniform_level_access" {
  type    = bool
  default = false
}

variable "acl" {
  type    = map(string)
  default = {}
}

variable "website_index" {
  type    = string
  default = null
}

variable "website_not_found" {
  type    = string
  default = null
}
