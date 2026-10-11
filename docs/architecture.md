# Decisiones de arquitectura

La solución conserva los CIDR y flujos del diagrama. México Central se usa porque admite Bastion Developer gratuito. La subred `AzureBastionSubnet` se mantiene para representar la topología y permitir una futura migración a Bastion dedicado, aunque Developer usa infraestructura compartida y se asocia directamente a la VNet.

PostgreSQL y Storage tienen acceso público deshabilitado. Sus Private Endpoints usan las direcciones del diagrama (`10.0.2.4` y `10.0.4.4`) y zonas DNS privadas enlazadas a la VNet.

La App Service y la VM tienen identidad administrada y el rol `Storage Blob Data Contributor`. PostgreSQL admite Microsoft Entra, pero el usuario/rol de cada identidad se crea dentro del motor después del despliegue; no es un recurso ARM y por eso no se finge como completado por Terraform.

