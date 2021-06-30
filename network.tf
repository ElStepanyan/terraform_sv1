resource "aws_vpc" "tr_vpc" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "tf"
  }
}

resource "aws_subnet" "tr_subnet_1" {
  vpc_id                  = aws_vpc.tr_vpc.id
  cidr_block              = "10.1.0.0/20"
  availability_zone       = "us-west-2a"

  map_public_ip_on_launch = true

  tags = {
    Name = "tf"
  }
}

resource "aws_subnet" "tr_subnet_2" {
  vpc_id                  = aws_vpc.tr_vpc.id
  cidr_block              = "10.1.16.0/20"
  availability_zone       = "us-west-2b"

  map_public_ip_on_launch = true

  tags = {
    Name = "tf"
  }
}

resource "aws_internet_gateway" "tr_gw" {
  vpc_id = aws_vpc.tr_vpc.id

  tags = {
    Name = "tf"
  }
}

resource "aws_default_route_table" "tr_rt" {
  default_route_table_id = aws_vpc.tr_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tr_gw.id
  }

  tags = {
    Name = "tf"
  }
}

