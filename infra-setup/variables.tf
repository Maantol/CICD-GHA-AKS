variable "azure_location" {
  type        = string
  default     = "North Europe"
  description = "Azure location for all resources"
}

variable "base_name" {
  type        = string
  default     = "webapp"
  description = "Base name for all resources"
}

variable "network_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}