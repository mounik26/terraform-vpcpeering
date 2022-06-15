variable "vpc_cidr" {
 default = "10.0.0.0/16"
}

variable "tenancy" {
 default = "default"
}

variable "tenancy1" {
 default = "default"
}

variable "publicsubnet_cidr" {
 default = "10.0.1.0/24"
}

variable "privatesubnet_cidr" {
 default = "10.0.2.0/24"
}

variable "testvpc_cidr" {
 default = "10.1.0.0/16"
}

variable "public1subnet_cidr" {
 default = "10.1.1.0/24"
}

variable "ami_id" {
 default = "ami-0f016ee9744d41846"
}

variable "ami_id1" {
 default = "ami-0fa49cc9dc8d62c84"
}

variable "instance_type" {
 default = "t2.micro"
}

variable "key_pair" {
  type    = string
  default = "Key.Pair"
}

