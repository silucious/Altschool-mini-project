#create vpc
resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc-cidr_block
  tags = {
    Name = var.vpc-name
  }
}

#create internet gateway for vpc

resource "aws_internet_gateway" "main-IG" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    "Name" = var.aws_internet_gateway-name
  }
}

#create public route table for internet gateway

resource "aws_route_table" "public-RT" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-IG.id

  }
  tags = {
    "Name" = var.route_table-name
  }

}

#create subnets for the vpc

resource "aws_subnet" "public-subnet1" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = var.subnet-cidr_block[0]
  availability_zone       = var.subnet-AZ[0]
  map_public_ip_on_launch = true
  tags = {
    "Name" = var.subnet-name[0]
  }
}

resource "aws_subnet" "public-subnet2" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = var.subnet-cidr_block[1]
  availability_zone       = var.subnet-AZ[1]
  map_public_ip_on_launch = true
  tags = {
    "Name" = var.subnet-name[1]
  }
}

#associate route table to the public subnets

resource "aws_route_table_association" "subnet1-association" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.public-RT.id
}

resource "aws_route_table_association" "subnet2-association" {
  subnet_id      = aws_subnet.public-subnet2.id
  route_table_id = aws_route_table.public-RT.id
}

