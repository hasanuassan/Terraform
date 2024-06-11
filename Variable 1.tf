# # Number of subnets to create
# variable "subnet_count" {
#   default = 4
# }
# variable "subnet_count_per_vnet" {
#   type    = number
#   default = 3
# }
# variable "vnet_address_spaces" {
#   description = "The address spaces for the VNETs"
#   default     = ["10.1.0.0/16", "10.2.0.0/16"]
# }

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "container_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "nic_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type = string
  sensitive = true
}

variable "cloud_init_script" {
  type = string
}

variable "data_disk_name" {
  type = string
}

variable "data_disk_size" {
  type = number
}
