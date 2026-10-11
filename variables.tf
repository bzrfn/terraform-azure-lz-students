variable "subscription_id" {
  description = "Azure subscription ID. Supply with TF_VAR_subscription_id; do not commit personal values."
  type        = string
  sensitive   = true

  validation {
    condition     = can(regex("^[0-9a-fA-F-]{36}$", var.subscription_id))
    error_message = "subscription_id must be a valid Azure subscription UUID."
  }
}

variable "location" {
  description = "Azure workload region allowed by the Azure for Students subscription policy."
  type        = string
  default     = "westus"
}

variable "resource_group_location" {
  description = "Metadata location of the existing resource group created during the initial validation."
  type        = string
  default     = "mexicocentral"
}

variable "environment" {
  description = "Environment name used in naming and tags."
  type        = string
  default     = "prod"
}

variable "name_prefix" {
  description = "Short naming prefix."
  type        = string
  default     = "lz"
}

variable "vnet_cidr" {
  description = "Address space for vnet-lz-prod."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  description = "Subnet CIDRs defined by the reference architecture."
  type        = map(string)
  default = {
    app       = "10.0.1.0/24"
    db        = "10.0.2.0/24"
    vm        = "10.0.3.0/24"
    endpoints = "10.0.4.0/24"
    bastion   = "10.0.5.0/24"
  }
}

variable "vm_size" {
  description = "Economical ARM worker VM with verified regional availability and quota."
  type        = string
  default     = "Standard_B2pts_v2"
}

variable "app_service_sku" {
  description = "Linux App Service plan SKU supporting VNet integration."
  type        = string
  default     = "B1"
}

variable "postgresql_sku" {
  description = "PostgreSQL Flexible Server burstable SKU."
  type        = string
  default     = "B_Standard_B1ms"
}

variable "vm_admin_username" {
  description = "Local Linux administrator name."
  type        = string
  default     = "azureadmin"
}

variable "vm_admin_ssh_public_key" {
  description = "SSH public key supplied at deploy time; never commit the private key."
  type        = string
  sensitive   = true
}

variable "postgresql_admin_username" {
  description = "Bootstrap PostgreSQL administrator."
  type        = string
  default     = "pgadminlz"
}

variable "postgresql_admin_password" {
  description = "Bootstrap password supplied through TF_VAR_postgresql_admin_password."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.postgresql_admin_password) >= 12
    error_message = "postgresql_admin_password must contain at least 12 characters."
  }
}

variable "entra_admin_principal_name" {
  description = "UPN of the PostgreSQL Microsoft Entra administrator."
  type        = string
  default     = "al222310320@utvtol.edu.mx"
}

variable "tags" {
  description = "Additional resource tags."
  type        = map(string)
  default = {
    Owner       = "Brandon Bernal"
    Activity    = "Terraform-4"
    CostControl = "Azure-for-Students"
  }
}

