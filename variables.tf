variable "owner" {
  description = "The owner of the resources."
  type        = string
}

variable "cost_center" {
  description = "The cost center for the resources."
  type        = string
}

variable "worker_count_request_30b5080f2088" {
  description = "The number of workers for the service plan."
  type        = number
}

variable "administrator_password_wo" {
  description = "The administrator password for the PostgreSQL server."
  type        = string
  sensitive   = true
  ephemeral   = true
}

variable "private_endpoints" {
  description = "Exact approved private_endpoints instances, keyed by blob, queue and table."
  type = map(object({
    name              = string
    subresource_names = list(string)
    dns_zone_key      = string
  }))
}

variable "private_dns_zones" {
  description = "Exact approved private_dns_zones instances, keyed by blob, queue and table."
  type = map(object({
    name = string
  }))
}

variable "dns_zone_links" {
  description = "Exact approved dns_zone_links instances, keyed by blob, queue and table."
  type = map(object({
    name                 = string
    dns_zone_key         = string
    registration_enabled = bool
  }))
}

variable "role_assignments" {
  description = "Exact approved role_assignments instances, keyed by blob, queue and table."
  type = map(object({
    name                 = string
    role_definition_name = string
  }))
}
