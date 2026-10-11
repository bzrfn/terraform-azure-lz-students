variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "name_prefix" { type = string }
variable "web_app_name" { type = string }
variable "app_service_sku" { type = string }
variable "app_subnet_id" { type = string }
variable "postgresql_fqdn" { type = string }
variable "storage_blob_url" { type = string }
variable "tags" { type = map(string) }

