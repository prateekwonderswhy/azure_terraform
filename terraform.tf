terraform {
    backend  "azurerm" {
        resource_group_name = "remote-state"
        storage_account_name = "prateekremotestate"
        container_name = "tfstates"
        key = "web.tfstate"
    }
}