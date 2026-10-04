output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "vm_name" {
  value = azurerm_linux_virtual_machine.vm.name
}

output "storage_account_name" {
  value = azurerm_storage_account.main.name
}

output "key_vault_name" {
  value = azurerm_key_vault.main.name
}

output "storage_blob_hostname" {
  value = "${azurerm_storage_account.main.name}.blob.core.windows.net"
}

output "key_vault_hostname" {
  value = "${azurerm_key_vault.main.name}.vault.azure.net"
}

output "blob_private_ip" {
  value = azurerm_private_endpoint.blob.private_service_connection[0].private_ip_address
}

output "key_vault_private_ip" {
  value = azurerm_private_endpoint.kv.private_service_connection[0].private_ip_address
}
