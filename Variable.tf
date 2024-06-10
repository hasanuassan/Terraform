# Number of subnets to create
variable "subnet_count" {
  default = 4
}
variable "subnet_count_per_vnet" {
  type    = number
  default = 3
}
variable "vnet_address_spaces" {
  description = "The address spaces for the VNETs"
  default     = ["10.1.0.0/16", "10.2.0.0/16"]
}