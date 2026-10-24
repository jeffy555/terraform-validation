resource "azurerm_resource_group" "onboarding_test" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_user_assigned_identity" "onboarding_test" {
  name                = var.identity_name
  resource_group_name = azurerm_resource_group.onboarding_test.name
  location            = azurerm_resource_group.onboarding_test.location
  tags                = local.common_tags
}

resource "azurerm_role_assignment" "project_reader" {
  role_definition_name = var.role_definition_name
  scope                = var.role_scope
  principal_id         = azurerm_user_assigned_identity.onboarding_test.principal_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_network_security_group" "security_test" {
  name                = var.nsg_name
  resource_group_name = azurerm_resource_group.onboarding_test.name
  location            = azurerm_resource_group.onboarding_test.location
  tags                = local.common_tags
}


# Import the administrator-created project resource group.
import {
  to = azurerm_resource_group.onboarding_test
  id = "/subscriptions/be1b0fcb-1e30-4142-bb0c-ff52f7a1a0e5/resourceGroups/rg-spiritops-onboarding-test-dev"
}
