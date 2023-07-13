variable "vpc_id" {
    type = string
}

variable "my_ip_with_cidr" {
    type = string
    description = "provide your ip for ssh into the server"
}

variable "public_key" {
    type = string
}

variable "private_key" {
    type = string
}
variable "instance_type" {
    type = string
}
    
variable "server_name" {
    type = string
  
}