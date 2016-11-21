# tf-azure-arm
Azure RM + Terraform

Sample terraform configuration files to provision and deploy  VMs in Azure Resource Manager.

##Running Windows VMs for an N-tier architecture on Azure

![alt](https://docs.microsoft.com/en-us/azure/guidance/media/blueprints/compute-n-tier.png)

[More information on N-tier architecture on Azure](https://docs.microsoft.com/en-us/azure/guidance/guidance-compute-n-tier-vm)

[More information on Azure Automation DSC](https://docs.microsoft.com/en-us/azure/automation/automation-dsc-getting-started)

[More information on Terraform's Microsoft Azure Provider](https://www.terraform.io/docs/providers/azurerm/index.html)

Instructions:
* Download latest version of Terraform for Windows, [here.] (https://www.terraform.io/downloads.html) to a local folder, eg. c:\Terraform
* Set path system environmental variable, in PowerShell type $env:Path = "c:\Terraform";
* Launch PowerShell (cmd or git bash) and type terraform to confirm installation.
* Code using any text editor, Visual Studio Code strongly recommended ( there is a Terraform extension for VSC).
* Register new application in Azure Active Directory using the Classic Portal, [see intructions here](https://www.terraform.io/docs/providers/azurerm/index.html) and 
assign the Contributor IAM role to the application user account in the ARM Portal.
* Create a terraform.tfvars with the credentials (do not version control this file).


    ARM_SUBSCRIPTION_ID = "..."
    ARM_CLIENT_ID = "..."
    ARM_CLIENT_SECRET = "..."
    ARM_TENANT_ID = "..."

    admin_username = "..."
    admin_password = "..."

