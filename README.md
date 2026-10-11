# Terraform Azure Landing Zone — Azure for Students

> Nota de región: la política de esta suscripción Azure for Students permite los
> recursos de trabajo en `westus`. El grupo conserva su ubicación de metadatos
> original en `mexicocentral`; Azure permite recursos de otras regiones dentro
> de un grupo de recursos.

Infraestructura modular basada en la arquitectura de referencia de la Actividad 14. Implementa una VNet con cinco subredes, App Service Linux, VM worker, Azure Bastion Developer, PostgreSQL Flexible Server, Blob Storage, Private Endpoints, DNS privado, identidades administradas y RBAC.

## Arquitectura

- VNet `vnet-lz-prod`: `10.0.0.0/16`
- Subredes: aplicación, base de datos, VM, endpoints y `AzureBastionSubnet`
- App Service B1 con integración VNet e identidad administrada
- VM Linux sin IP pública, accesible solo con Bastion
- PostgreSQL B1ms y Blob Storage sin acceso público
- Private Link y DNS privado para PostgreSQL y Blob
- RBAC `Storage Blob Data Contributor` para App Service y VM

## Requisitos

- Terraform 1.7 o superior
- Azure CLI con la suscripción correcta
- Una llave pública SSH y una contraseña temporal segura para PostgreSQL

## Despliegue

```bash
export TF_VAR_subscription_id="<subscription-id>"
export TF_VAR_vm_admin_ssh_public_key="$(cat ~/.ssh/id_ed25519.pub)"
export TF_VAR_postgresql_admin_password="<secure-temporary-password>"

terraform fmt -recursive
terraform init
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

No se almacenan credenciales, estados ni llaves privadas en Git. El rol de base de datos para las identidades administradas debe crearse dentro de PostgreSQL después del despliegue usando el administrador de Microsoft Entra.

## Costos y limpieza

Bastion Developer es gratuito. App Service B1, VM B2pts_v2, PostgreSQL B1ms y Private Endpoints sí generan costo. Al terminar las evidencias, revisar primero `terraform plan -destroy` y destruir solo con autorización.

