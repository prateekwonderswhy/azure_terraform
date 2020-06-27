terraform{
    backend "azurerm" {
        resource_group_name = "remote-state"
        storage_account_name = "terraformprateek"
        container_name = "tfstate"
        key = "terraform.tfstate"
    }
}