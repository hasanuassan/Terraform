#Import Resource Group
data "azurerm_resource_group" "RG" {
  name = "HassanRG"
}
#SG
resource "azurerm_storage_account" "terraform-azure-storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
#CN
resource "azurerm_storage_container" "terraform-azure-container" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}
#Nic
resource "azurerm_network_interface" "terraform-azure-nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}
#VM
resource "azurerm_virtual_machine" "terraform-azure-vm" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = var.vm_size

  storage_os_disk {
    name              = "${var.vm_name}_osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name              = var.data_disk_name
    lun               = 0
    caching           = "ReadWrite"
    create_option     = "Empty"
    disk_size_gb      = var.data_disk_size
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = var.vm_name
    admin_username = var.admin_username
    admin_password = var.admin_password
    custom_data    = var.cloud_init_script
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# # Create VNETs
# resource "azurerm_virtual_network" "vnet" {
#   count               = 2
#   name                = "VNET-${count.index + 1}"
#   resource_group_name = data.azurerm_resource_group.RG.name
#   location            = "Southeast Asia"
#   address_space       = [var.vnet_address_spaces[count.index]]
# }

# #Subnet
# resource "azurerm_subnet" "subnet" {
#   count                = var.subnet_count
#   name                 = "example-subnet-${count.index + 1}"
#   resource_group_name  = data.azurerm_resource_group.RG.name
#   virtual_network_name = azurerm_virtual_network.vnet[floor(count.index / var.subnet_count_per_vnet)].name
#   #cidrsubnet("172.16.0.0/12", 4, 2)
#   address_prefixes     = [cidrsubnet(var.vnet_address_spaces[floor(count.index / var.subnet_count_per_vnet)], 8, count.index % var.subnet_count_per_vnet)] 
# }
# #Security Group

# resource "azurerm_network_security_group" "SG" {
#   name                = "nsg"
#   location            = data.azurerm_resource_group.RG.location
#   resource_group_name = data.azurerm_resource_group.RG.name

#   security_rule {
#     name                       = "allow-ssh"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "22"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

#   security_rule {
#     name                       = "allow-http"
#     priority                   = 200
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "80"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }

# #
# resource "azurerm_subnet_network_security_group_association" "example" {
#   count                     = length(azurerm_subnet.subnet)
#   subnet_id                 = azurerm_subnet.subnet[count.index].id
#   network_security_group_id = azurerm_network_security_group.example.id
# }
