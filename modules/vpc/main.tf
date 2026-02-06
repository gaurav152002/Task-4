##=== VPC module ===##
resource "aws_vpc" "this" {
    cidr_block = var.vpc_cidr

    tags = {
     name = "${var.env}-vpc"
    }
  
}

##================================= Subnets ===================================================##

##===== Public Subnet =====##
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.this.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"

    tags = {
      name = "${var.env}--public subnet"
    }
}

##===== Public Subnet (aws security reason) =====##
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"

  tags = {
    Name = "${var.env}-public-subnet-2"
  }
}


##===== Private Subnet =====##
resource "aws_subnet" "private" {
    vpc_id = aws_vpc.this.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1a"

    tags = {
      name = "${var.env}--private subnet"
    }
}

##================================= Gateway ===================================================##

##=== Internet Gateway =====##
resource "aws_internet_gateway" "this" {
    vpc_id = aws_vpc.this.id
    tags = {
      name = "${var.env}--internet gateway"
  }
}

##=== Route Table ===##
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.this.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.this.id
    }
    tags = {
      name = "${var.env}--public route table"
    }
}

##=== Route Table association ===##
resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
}

##=== Route Table association ( for 2nd public subnet , aws security) ===##
resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}


##=== Elastic IP for NAT Gateway ===##
resource "aws_eip" "nat" {
    domain = "vpc"
    tags = {
      name = "${var.env}--nat-elastic-ip"
    }
  
}

##=== NAT Gateway ===##
resource "aws_nat_gateway" "this" {
    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.public.id

    tags = {
      name = "${var.env}--nat gateway"
   } 
}

###=== Route Table for private subnet ===##
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.this.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.this.id  
    }
    tags = {
        name = "${var.env}--private route table"
    }
}

##=== Route Table association for private subnet ===##
resource "aws_route_table_association" "private" {
    subnet_id = aws_subnet.private.id
    route_table_id = aws_route_table.private.id
}