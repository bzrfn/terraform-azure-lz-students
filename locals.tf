locals {
  suffix            = substr(replace(nonsensitive(var.subscription_id), "-", ""), 0, 8)
  resource_group    = "rg-${var.name_prefix}-${var.environment}-mxc-001"
  storage_name      = lower("st${var.name_prefix}${var.environment}${local.suffix}")
  web_app_name      = lower("app-${var.name_prefix}-${var.environment}-${local.suffix}")
  postgresql_name   = lower("psql-${var.name_prefix}-${var.environment}-${local.suffix}")
  normalized_prefix = "${var.name_prefix}-${var.environment}"

  common_tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "Terraform"
  })
}

