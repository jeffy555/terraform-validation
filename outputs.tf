output "resource_group_name" {
  value = azurerm_resource_group.apptest.name
}

output "storage_account_name" {
  value = azurerm_storage_account.apptest.name
}

output "service_plan_id" {
  value = azurerm_service_plan.apptest.id
}


output "postgresql_server_name" {
  value = azurerm_postgresql_flexible_server.apptest.name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.apptest.name
}

output "subnet_functions_name" {
  value = azurerm_subnet.function_integration.name
}

output "subnet_private_endpoints_name" {
  value = azurerm_subnet.private_endpoints.name
}
