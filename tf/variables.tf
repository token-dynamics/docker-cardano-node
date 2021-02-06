variable "aws_profile" {
    type = string
    default = "token-dynamics"
}

variable "aws_region" {
    type = string
    default = "us-west-2"
}

variable "relay_instance_size" {
    type = string
}

variable "core_instance_size" {
    type = string
}

variable "core_key_pair_name" {
    type = string
    default = "td-cardano-core"
}

variable "relay_key_pair_name" {
    type = string
    default = "td-cardano-relay"
}