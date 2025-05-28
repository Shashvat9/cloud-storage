variable "DB_password" {
  description = "The password for the database admin user"
  type        = string
#   sensitive   = true
  default = "Cloud-storage123"
}

variable "DB_username" {
  description = "The username for the database admin user"
  type        = string
  default     = "admin"
}