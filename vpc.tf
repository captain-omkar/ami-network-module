resource "aws_vpc" "AMI_vpc" {
    cidr_block       = var.vpc_cidr
    tags = {
    Name = "AMI-Network-vpc"
     }
}

# Internet Gateway
resource "aws_internet_gateway" "terra_igw" {
  vpc_id = aws_vpc.AMI_vpc.id
  tags = {
    Name = "AMI-Network-us-east-1-IGW"
  }
}

resource "aws_subnet" "private1" {
  for_each = var.private_subnets_1
  availability_zone = "ap-south-1a"
  vpc_id   = aws_vpc.AMI_vpc.id
  cidr_block = each.value["cidr"]
  
  tags = {
    Name = each.value["name"]
  }
}

resource "aws_subnet" "private2" {
  for_each = var.private_subnets_2
  availability_zone = "ap-south-1a"
  vpc_id   = aws_vpc.AMI_vpc.id
  cidr_block = each.value["cidr"]
  
  tags = {
    Name = each.value["name"]
  }
}

resource "aws_subnet" "public" {
  for_each = var.public_subnets
  availability_zone = "ap-south-1a"
  vpc_id   = aws_vpc.AMI_vpc.id
  cidr_block = each.value["cidr"]
  
  tags = {
    Name = each.value["name"]
  }
}


