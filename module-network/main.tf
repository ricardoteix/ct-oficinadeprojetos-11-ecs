variable "region" {
    type    = string
    default = "us-east-1"
}

variable "zones" {
  type = list(string)
  default = [ "a", "b", "c", "d", "e", "f" ]
}

variable "vpc_cidr_block" {
    type    = string
    default = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
    type    = bool
    default = true
}

variable "enable_dns_support" {
    type    = bool
    default = true
}

variable "tags-sufix" {
    type    = string
    default = ""
}

variable "public_subnet_cidr_blocks" {
    type    = list(string)
}

variable "private_subnet_cidr_blocks" {
    type    = list(string)
}

variable "use_nat" {
    type = bool
    default = false
}
