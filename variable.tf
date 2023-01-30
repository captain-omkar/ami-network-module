variable "vpc_cidr" {
}

variable "vpc_name" {
}

variable "IG_name" {
}



variable "private_subnets_1" {
   type = map(map(string))
}

variable "private_subnets_2" {
   type = map(map(string))
}

variable "public_subnets" {
   type = map(map(string))
   
}

variable "public_subnet_nat1" {
   type = map(string)
}

variable "public_subnet_nat2" {
   type = map(string)
}






