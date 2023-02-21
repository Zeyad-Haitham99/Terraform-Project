provider "aws" {
  region = "us-east-1"
}
variable "cidrblock" {
  description = "cidr block "
  type = list(string)   
}
resource "aws_vpc" "deployment-vpc" {
  cidr_block = var.cidrblock[0]
}
resource "aws_subnet" "dev-subnet" {
  vpc_id = aws_vpc.deployment-vpc.id
  cidr_block = var.cidrblock[1]
  availability_zone = "us-east-1a"
}

data "aws_vpc" "existing_vpc" {
default = true
}

resource "aws_subnet" "dev-subnet-2" {
  vpc_id = data.aws_vpc.existing_vpc.id
  cidr_block = "172.31.96.0/20"
  availability_zone = "us-east-1a"
}