variable "resource_group_name" {
  default     = "rg-suseapril22-staging-westeur"
  description = "Resource group name"
}

variable "resource_group_location" {
  default     = "westeurope"
  description = "Resource group location"
}

variable "vm_admin_username" {
  default = ""
}

variable "vm_admin_password" {
  default = ""
}

variable "os_publisher" {
  default = ""
}

variable "os_offer" {
  default = ""
}

variable "os_sku" {
  default = ""
}

variable "os_version" {
  default = "latest"
}
