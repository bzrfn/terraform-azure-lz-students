variable "resource_group_id" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "name_prefix" { type = string }
variable "suffix" { type = string }
variable "vm_subnet_id" { type = string }
variable "vnet_id" { type = string }
variable "vm_size" { type = string }
variable "admin_username" { type = string }
variable "admin_ssh_public_key" {
  type      = string
  sensitive = true
}
variable "deploy_developer_bastion" { type = bool }
variable "tags" { type = map(string) }

