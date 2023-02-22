provider "aws" {
  region = "us-east-1"
}
variable "vpc_cider_block" {
 description = "deployment vpc"
}
variable "subnet_cider_block" {
  description = "deployment subnet"
}
resource "aws_vpc" "deployment-vpc" {
  cidr_block = var.vpc_cider_block
  tags = {
    "Name" = "dev-vpc"
  }
}
resource "aws_subnet" "dev-subnet" {
  vpc_id = aws_vpc.deployment-vpc.id
  cidr_block = var.subnet_cider_block
  availability_zone = "us-east-1a"
  tags = {
    Name:"dev-subnet"
  }
}
resource "aws_internet_gateway" "dev-gateway" {
  vpc_id = aws_vpc.deployment-vpc.id
}

resource "aws_default_route_table" "dev-rtb-default" {
  default_route_table_id = aws_vpc.deployment-vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/10"
    gateway_id = aws_internet_gateway.dev-gateway.id
  }
  tags ={
    Name:"dev-Route-Table"
  }
}
resource "aws_default_security_group" "dev-security-group" {
  
  vpc_id = aws_vpc.deployment-vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["41.234.33.67/32"]
  }
    ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
  tags = {
    Name:"dev-Security-Group"
  }
}
