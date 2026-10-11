variable "resource_group_id" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "suffix" { type = string }
variable "storage_account_name" { type = string }
variable "postgresql_server_name" { type = string }
variable "postgresql_sku" { type = string }
variable "postgresql_admin_username" { type = string }
variable "postgresql_admin_password" {
  type      = string
  sensitive = true
}
variable "entra_admin_object_id" { type = string }
variable "entra_admin_principal_name" { type = string }
variable "tenant_id" { type = string }
variable "db_subnet_id" { type = string }
variable "endpoints_subnet_id" { type = string }
variable "vnet_id" { type = string }
variable "tags" { type = map(string) }

