variable "region" {
    type    = string
    default = "us-east-1"
}

variable "vpc-id" {
    type    = string
}

variable "tags-sufix" {
    type    = string
    default = ""
}

variable "db-name" {
    type    = string
}

variable "db-port" {
    type    = number
}
