variable "key_spec" {
  default = "SYMMETRIC_DEFAULT"
}

variable "kms_s3_alias" {
  default = "s3_kms"
}

variable "enabled" {
  default = true
}

variable "rotation_enabled" {
  default = true
}
