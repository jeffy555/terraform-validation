terraform {
  backend "azurerm" {
    resource_group_name = "AICloudBuilder"
    storage_account_name = "spiritopsbackend"
    container_name = "test"
    key = "projects/jeffy555-terraform-validation/9617b6d0d4ec7b27f772/terraform.tfstate"
    use_azuread_auth = true
  }
}
