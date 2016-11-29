# https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-nsg
#
# Allow SQL and RDP.  Deny HTTP from tier1,tier2 and Internet 

resource "azurerm_network_security_group" "tier3_fw" {
  name                = "sql_fw"
  location            = "${azurerm_resource_group.ResourceGrps.location}"
  resource_group_name = "${azurerm_resource_group.ResourceGrps.name}"

  security_rule {
    name                       = "allow-sql"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "10.0.2.0/24"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-RDP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "10.0.3.0/24"
    destination_address_prefix = "10.0.0.128/25"
  }

  security_rule {
    name                       = "Deny-tier2-inTraffic"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "10.0.2.0/24"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Deny-tier2-outTraffic"
    priority                   = 210
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.2.0/24"
  }

  security_rule {
    name                       = "Deny-tier1-inTraffic"
    priority                   = 220
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Deny-tier1-outTraffic"
    priority                   = 230
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.1.0/24"
  }

  security_rule {
    name                       = "Deny-Internet-inTraffic"
    priority                   = 240
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Deny-Internet-outTraffic"
    priority                   = 250
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "0.0.0.0/0"
  }
}
