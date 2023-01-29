

variable "vpc_cidr" {
    default = "10.96.0.0/21"
}


variable "private_subnets_1" {
   type = map
   default = {
      sub-1 = {
         name = "ami-network-tgw-subnet-1"
         cidr = "10.96.7.0/27"
      }
      sub-2 = {
         name = "ami-network-trust-subnet-1"
         cidr = "10.96.2.0/27"
      }

      sub-3 = {
        name = "ami-network-app-subnet-1"
        cidr = "10.96.6.0/25"
        }
      
   }
}

variable "private_subnets_2" {
   type = map
   default = {
      sub-1 = {
         name = "ami-network-tgw-subnet-2"
         cidr = "10.96.7.32/27"
      }
      sub-2 = {
         name = "ami-network-trust-subnet-2"
         cidr = "10.96.2.32/27"
      }

      sub-3 = {
        name = "ami-network-app-subnet-2"
        cidr = "10.96.6.128/25"
        }
      
   }
}

variable "public_subnets" {
   type = map
   default = {
      
      sub-1 = {
        name = "ami-network-untrust-subnet-1"
        cidr = "10.96.0.0/24"
        }

      sub-2 = {
         name = "ami-network-untrust-subnet-2"
         cidr = "10.96.1.0/24"
      }
      sub-3 = {
         name = "ami-network-management-subnet-1	 "
         cidr = "10.96.3.0/28"
      }

      sub-4 = {
        name = "ami-network-management-subnet-2	"
        cidr = "10.96.3.16/28"
        }  
      
   }
}

variable "public_subnet_nat1" {
   type = map
   default = {
         name = "ami-network-lb-subnet-1"
         cidr = "10.96.4.0/24"
      }
      
}

variable "public_subnet_nat2" {
   type = map
   default = {
         name = "ami-network-lb-subnet-2"
         cidr = "10.96.5.0/24"
      }

}




