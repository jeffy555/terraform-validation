variable "owner" {
  description = "The owner of the resources."
  type        = string
}

variable "cost_center" {
  description = "The cost center for the resources."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The location/region where the resources are created."
  type        = string
}

variable "identity_name" {
  description = "The name of the user-assigned identity."
  type        = string
}

variable "role_definition_name" {
  description = "The name of the role to assign."
  type        = string
}

variable "role_scope" {
  description = "The scope at which the role assignment applies."
  type        = string
}

variable "nsg_name" {
  description = "The name of the network security group."
  type        = string
}
