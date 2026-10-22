resource "azurerm_resource_group" "apptest" {
  name     = "rg-spiritops-apptest-dev"
  location = "southindia"
  tags     = local.required_tags
}

resource "azurerm_storage_account" "apptest" {
  name                            = "stspiritopsapptest01"
  resource_group_name             = azurerm_resource_group.apptest.name
  location                        = azurerm_resource_group.apptest.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  account_kind                    = "StorageV2"
  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = false
  shared_access_key_enabled       = false
  allow_nested_items_to_be_public = false
  tags                            = local.required_tags
}

resource "azurerm_service_plan" "apptest" {
  name                = "asp-spiritops-apptest-dev"
  resource_group_name = azurerm_resource_group.apptest.name
  location            = azurerm_resource_group.apptest.location
  os_type             = "Linux"
  sku_name            = "B1"
  worker_count        = var.worker_count_request_30b5080f2088
  tags                = local.required_tags
}

resource "azurerm_linux_web_app" "apptest" {
  name                = "app-spiritops-apptest-dev"
  resource_group_name = azurerm_resource_group.apptest.name
  location            = azurerm_resource_group.apptest.location
  service_plan_id     = azurerm_service_plan.apptest.id
  https_only          = true

  site_config {
    application_stack {
      python_version = "3.12"
    }
  }

  tags = local.required_tags
}

resource "azurerm_postgresql_flexible_server" "apptest" {
  name                              = "pg-spiritops-apptest-dev"
  resource_group_name               = azurerm_resource_group.apptest.name
  location                          = azurerm_resource_group.apptest.location
  sku_name                          = "B_Standard_B1ms"
  version                           = "16"
  storage_mb                        = 32768
  administrator_login               = "spiritopsadmin"
  administrator_password_wo         = var.administrator_password_wo
  administrator_password_wo_version = 1
  public_network_access_enabled     = false
  tags                              = local.required_tags
}

resource "azurerm_linux_function_app" "apptest" {
  name                          = "func-spiritops-apptest-dev"
  resource_group_name           = azurerm_resource_group.apptest.name
  location                      = azurerm_resource_group.apptest.location
  service_plan_id               = azurerm_service_plan.apptest.id
  storage_account_name          = azurerm_storage_account.apptest.name
  storage_uses_managed_identity = true
  virtual_network_subnet_id     = azurerm_subnet.function_integration.id
  https_only                    = true

  site_config {
    always_on              = true
    vnet_route_all_enabled = true
    application_stack {
      python_version = "3.12"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "AzureWebJobsStorage__accountName" = azurerm_storage_account.apptest.name
  }

  tags = local.required_tags
}

resource "azurerm_virtual_network" "apptest" {
  name                = "vnet-spiritops-apptest-dev"
  resource_group_name = azurerm_resource_group.apptest.name
  location            = azurerm_resource_group.apptest.location
  address_space       = ["10.68.0.0/24"]
  tags                = local.required_tags
}

resource "azurerm_subnet" "function_integration" {
  name                 = "snet-functions"
  resource_group_name  = azurerm_resource_group.apptest.name
  virtual_network_name = azurerm_virtual_network.apptest.name
  address_prefixes     = ["10.68.0.0/27"]

  delegation {
    name = "Microsoft.Web/serverFarms"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "private_endpoints" {
  name                 = "snet-private-endpoints"
  resource_group_name  = azurerm_resource_group.apptest.name
  virtual_network_name = azurerm_virtual_network.apptest.name
  address_prefixes     = ["10.68.0.64/27"]
}

resource "azurerm_private_endpoint" "storage" {
  for_each            = var.private_endpoints
  tags                = local.required_tags
  name                = each.value.name
  resource_group_name = azurerm_resource_group.apptest.name
  location            = azurerm_resource_group.apptest.location
  subnet_id           = azurerm_subnet.private_endpoints.id

  private_service_connection {
    name                           = each.value.name
    private_connection_resource_id = azurerm_storage_account.apptest.id
    is_manual_connection           = false
    subresource_names              = each.value.subresource_names
  }

  private_dns_zone_group {
    name                 = each.value.name
    private_dns_zone_ids = [azurerm_private_dns_zone.storage[each.value.dns_zone_key].id]
  }
}

resource "azurerm_private_dns_zone" "storage" {
  for_each            = var.private_dns_zones
  tags                = local.required_tags
  name                = each.value.name
  resource_group_name = azurerm_resource_group.apptest.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage" {
  for_each              = var.dns_zone_links
  tags                  = local.required_tags
  name                  = each.value.name
  resource_group_name   = azurerm_resource_group.apptest.name
  private_dns_zone_name = azurerm_private_dns_zone.storage[each.value.dns_zone_key].name
  virtual_network_id    = azurerm_virtual_network.apptest.id
  registration_enabled  = each.value.registration_enabled
}

resource "azurerm_role_assignment" "function_storage" {
  for_each             = var.role_assignments
  name                 = each.value.name
  scope                = azurerm_storage_account.apptest.id
  role_definition_name = each.value.role_definition_name
  principal_id         = azurerm_linux_function_app.apptest.identity[0].principal_id
  principal_type       = "ServicePrincipal"
}


# Import the administrator-created project resource group.
import {
  to = azurerm_resource_group.apptest
  id = "/subscriptions/be1b0fcb-1e30-4142-bb0c-ff52f7a1a0e5/resourceGroups/rg-spiritops-apptest-dev"
}
resource "azurerm_user_assigned_identity" "permission_test" {
  name                = "id-spiritops-permission-test-dev"
  resource_group_name = azurerm_resource_group.apptest.name
  location            = azurerm_resource_group.apptest.location
  tags                = local.required_tags
}

resource "azurerm_role_assignment" "permission_test_storage_reader" {
  role_definition_name = "Reader"
  scope                = azurerm_storage_account.apptest.id
  principal_id         = azurerm_user_assigned_identity.permission_test.principal_id
  principal_type       = "ServicePrincipal"
}
resource "azurerm_network_security_group" "e2e_test" {
  name                = "nsg-spiritops-e2e-dev"
  resource_group_name = azurerm_resource_group.apptest.name
  location            = azurerm_resource_group.apptest.location
  tags                = local.required_tags
}
resource "azurerm_user_assigned_identity" "cleanup_round" {
  name                = "id-spiritops-cleanup-round-dev"
  resource_group_name = azurerm_resource_group.apptest.name
  location            = azurerm_resource_group.apptest.location
  tags                = local.required_tags
}

resource "azurerm_role_assignment" "cleanup_round_storage_reader" {
  role_definition_name = "Reader"
  scope                = azurerm_storage_account.apptest.id
  principal_id         = azurerm_user_assigned_identity.cleanup_round.principal_id
  principal_type       = "ServicePrincipal"
}
