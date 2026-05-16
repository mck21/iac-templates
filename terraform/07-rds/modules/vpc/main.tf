resource "aws_vpc" "mi_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "subnet_publica" {
  vpc_id                  = aws_vpc.mi_vpc.id
  cidr_block              = var.subnet_publica_cidr
  availability_zone       = var.az1
  map_public_ip_on_launch = true

  tags = {
    Name = "Subred Pública"
  }
}

resource "aws_subnet" "subnet_privada" {
  vpc_id            = aws_vpc.mi_vpc.id
  cidr_block        = var.subnet_privada_cidr
  availability_zone = var.az1

  tags = {
    Name = "Subred Privada 1"
  }
}

resource "aws_subnet" "subnet_privada2" {
  vpc_id            = aws_vpc.mi_vpc.id
  cidr_block        = var.subnet_privada2_cidr
  availability_zone = var.az2

  tags = {
    Name = "Subred Privada 2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mi_vpc.id

  tags = {
    Name = "Internet Gateway"
  }
}

resource "aws_route_table" "rt_publica" {
  vpc_id = aws_vpc.mi_vpc.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.rt_publica.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "publica" {
  subnet_id      = aws_subnet.subnet_publica.id
  route_table_id = aws_route_table.rt_publica.id
}
