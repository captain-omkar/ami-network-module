resource "aws_vpc" "AMI_vpc" {
    cidr_block = var.vpc_cidr
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

resource "aws_subnet" "public_nat_1" {
  availability_zone = "ap-south-1a"
  vpc_id   = aws_vpc.AMI_vpc.id
  cidr_block = var.public_subnet_nat1["cidr"]
  
  tags = {
    Name = var.public_subnet_nat1["name"]
  }
}

resource "aws_subnet" "public_nat_2" {
  availability_zone = "ap-south-1a"
  vpc_id   = aws_vpc.AMI_vpc.id
  cidr_block = var.public_subnet_nat2["cidr"]
  
  tags = {
    Name = var.public_subnet_nat2["name"]
  }
}

resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.AMI_vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "10.3.0.0/18"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.3.0.0/18"
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "AMI-Network-Private-NACL"
  }
}

resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.AMI_vpc.id

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "10.3.0.0/18"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.3.0.0/18"
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "AMI-Network-Public-NACL"
  }
}

resource "aws_network_acl_association" "private_asc_1" {
  for_each = aws_subnet.private1
  network_acl_id = aws_network_acl.private.id
  subnet_id      = each.value.id
}

resource "aws_network_acl_association" "private_asc_2" {
  for_each = aws_subnet.private2
  network_acl_id = aws_network_acl.private.id
  subnet_id      = each.value.id
}

resource "aws_network_acl_association" "public_asc" {
  for_each = aws_subnet.public
  network_acl_id = aws_network_acl.public.id
  subnet_id      = each.value.id
}

resource "aws_network_acl_association" "public_asc_nat1" {
  network_acl_id = aws_network_acl.public.id
  subnet_id      = aws_subnet.public_nat_1.id
}

resource "aws_network_acl_association" "public_asc_nat2" {
  network_acl_id = aws_network_acl.public.id
  subnet_id      = aws_subnet.public_nat_2.id
}

resource "aws_nat_gateway" "nat1" {
  subnet_id = aws_subnet.public_nat_1.id
  allocation_id = aws_eip.eip1.id
  tags = {
    Name = "AMI-Network-us-east-1-NAT-1"
  }
}

resource "aws_eip" "eip1" {
  vpc = true
  tags = {
    Name = "AMI-Network-us-east-1-EIP-1"
  }
}

resource "aws_nat_gateway" "nat2" {
  subnet_id = aws_subnet.public_nat_2.id
  allocation_id = aws_eip.eip2.id
  tags = {
    Name = "AMI-Network-us-east-1-NAT-2"
  }
}

resource "aws_eip" "eip2" {
  vpc = true
  tags = {
    Name = "AMI-Network-us-east-1-EIP-2"
  }
}

resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.AMI_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat1.id
  }

  tags = {
    Name = "AMI-Network-Private-RT-1"
  }
}

resource "aws_route_table" "private2" {
  vpc_id = aws_vpc.AMI_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat2.id
  }

  tags = {
    Name = "AMI-Network-Private-RT-2"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.AMI_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra_igw.id
  }

  tags = {
    Name = "AMI-Network-Public-RT"
  }
}

resource "aws_route_table_association" "rt_asc_private1" {
  for_each = aws_subnet.private1
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private1.id
}

resource "aws_route_table_association" "rt_asc_private2" {
  for_each = aws_subnet.private2
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private2.id
}

resource "aws_route_table_association" "rt_asc_public" {
  for_each = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "rt_asc_public_nat1" {
  subnet_id      = aws_subnet.public_nat_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "rt_asc_public_nat2" {
  subnet_id      = aws_subnet.public_nat_2.id
  route_table_id = aws_route_table.public.id
}












