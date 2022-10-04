variable "resource_group_name" {
  description = "Name for resource group"
  default     = "rg"
  type        = string
}
variable "location" {
  description = "Azure location"
  default     = "East US"
}
variable "virtual_network_name" {
  description = "Virtual network name"
  default     = "vnet"
  type        = string
}
variable "environment" {
  description = "environment name"
  default     = "dev"
  type        = string
}
variable "service" {
  description = "service name"
  default     = "distri"
  type        = string
}

variable "vm_user" {
  description = "User name"
  default     = "adminUser"
  type        = string
}

variable "blob_type" {
  description = "Blob type"
  default     = "Block"
  type        = string
}