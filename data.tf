data "azurerm_key_vault" "key_vault" {
  name = "terraform-prateek"
  resource_group_name = "remote-state"
}

data "azurerm_key_vault_secret" "azure_public_key" {
  name = "azure-public-key"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault_secret" "ssh_private_key" {
  name = "ssh-private-key"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}