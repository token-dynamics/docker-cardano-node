variable "name" {
  type = string
}

variable "instance_size" {
  type = string
}

variable "volume_size" {
  type = number
  default = 30
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "node_port" {
  type = number
  default = "3001"
}

variable "key_pair_name" {
  type = string
}