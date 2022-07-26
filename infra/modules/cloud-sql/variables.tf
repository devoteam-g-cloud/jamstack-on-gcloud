variable "db_name" {
  type = string
}

variable "db_tier" {
  type    = string
  default = "db-custom-1-3840"
}

variable "db_version" {
  type    = string
  default = "POSTGRES_13"
}

variable "availability_type" {
  type    = string
  default = "REGIONAL"
}

variable "disk_autoresize" {
  type    = string
  default = true
}

variable "disk_size" {
  type    = number
  default = 10
}

variable "disk_type" {
  type    = string
  default = "PD_SSD"
}

variable "db_user_name" {
  type = string
}

variable "db_password_secret" {
  type    = string
  default = "db-password"
}
