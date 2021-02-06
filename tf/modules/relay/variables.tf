variable "relay_instance_size" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "relay_node_port" {
  type = number
  default = "3001"
}

variable "key_pair_name" {
  type = string
}