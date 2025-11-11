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
