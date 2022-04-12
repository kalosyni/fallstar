variable "resource_group_name" {
  default = "rg-demoapril22-staging-westeur"
}

variable "resource_group_location" {
  default = "westeurope"
}

variable "environment_name" {
  default     = "Demo"
  description = "Environment name"
}

variable "agent_count" {
  default = 2
}

variable "aks_service_principal_app_id" {
  description = "Service principal application id"
}

variable "aks_service_principal_client_secret" {
  description = "Service principal client secret"
}

# Standard_D2_v2, Standard_D2as_v5
variable "vm_size" {
  default = "Standard_D2as_v5"
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
  default = "demoapr22"
}

variable "cluster_name" {
  default = "demoapr22"
}

variable "location" {
  default = "West Europe"
}

variable "log_analytics_workspace_name" {
  default = "demoapr22"
}

# https://azure.microsoft.com/global-infrastructure/services/?products=monitor
variable "log_analytics_workspace_location" {
  default = "westeurope"
}

# https://azure.microsoft.com/pricing/details/monitor/
variable "log_analytics_workspace_sku" {
  default = "PerGB2018"
}
