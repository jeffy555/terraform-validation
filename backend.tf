terraform {
  backend "azurerm" {
    resource_group_name = "AICloudBuilder"
    storage_account_name = "spiritopsbackend"
    container_name = "test"
    key = "terraform-validation/dev/rebuild-20261013-a7f6cb70.tfstate"
    use_azuread_auth = true
  }
}
