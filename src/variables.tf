variable "subscription_id" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "vm_name" {
  type = string
  default = "myTFVM"
}

variable "location" {
  type = string
  default = "East US"
}

variable "vm_size" {
  type = string
  default = "Standard_DS1_v2"
}

variable "admin_username" {
  type = string
  default = "adminuser"
}

variable "admin_password" {
  type = string
}
