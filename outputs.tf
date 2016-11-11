output "resource_group" {
  value = "${azurerm_resource_group.ResourceGrps.name}"
}

output "storage_account" {
  value = "${azurerm_storage_account.stacc2.name}"
}

output "virtualnet" {
  value = "${azurerm_virtual_network.vnet1.name}"
}

output "VM_Name" {
  value = ["${azurerm_virtual_machine.vmtest.*.name}"]
}
