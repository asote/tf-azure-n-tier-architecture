# Get-AzureVMAvailableExtension | ? {$_.ExtensionName -eq "DSC"} # cmdlet to get available extensions
# References:
# https://blogs.endjin.com/2015/07/using-azure-resource-manager-and-powershell-dsc-to-create-and-provision-a-vm/
#
# https://docs.microsoft.com/en-us/azure/virtual-machines/virtual-machines-windows-extensions-dsc-overview
# Publish-AzureRmVMDscConfiguration ".\IIS-Install.ps1" -OutputArchivePath ".\IIS-Install.ps1.zip"


resource "azurerm_virtual_machine_extension" "DSC" {
  count                = "3"
  name                 = "DSC"
  location             = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name  = "${azurerm_resource_group.ResourceGrps.name}"
  virtual_machine_name = "${element(azurerm_virtual_machine.tier1-vm.*.name, count.index)}"
  publisher            = "Microsoft.Powershell"
  type                 = "DSC"
  type_handler_version = "2.20"

  settings = <<SETTINGS
  {
    "modulesUrl"      : "https://asotelostor.blob.core.windows.net/files/IIS-Install.ps1.zip",
    "sastoken" : "?sv=2015-04-05&ss=b&srt=o&sp=ra&se=2017-01-31T22:53:59Z&st=2016-11-20T14:53:59Z&spr=https&sig=4LTq%2FXvoqWXb1Wr0vWGy8uK%2FGTR5ix78SJrsfkspW%2FA%3D",
    "configurationFunction" : "IIS-Install.ps1\\IISInstall"
    "wmfVersion" : "latest"
  }
SETTINGS

  tags {
    environment = "Test"
  }
}
