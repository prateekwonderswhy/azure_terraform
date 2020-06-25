data "azurerm_key_vault" "key_vault" {
  name = "terraform-prateek"
  resource_group_name = "remote-state"
}

data "azurerm_key_vault_secret" "ssh_pub_key" {
  name = "ssh-pub-key"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}