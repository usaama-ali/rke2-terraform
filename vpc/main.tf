resource "aws_vpc" "rke2_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name      = var.vpc_name
    CreatedBy = "usama ali"
  }
}

resource "aws_internet_gateway" "rke2_igw" {
  vpc_id = aws_vpc.rke2_vpc.id

  tags = {
    Name      = "${var.vpc_name}_igw"
    CreatedBy = "usama ali"
  }
}

resource "aws_eip" "rke2_eip" {
  domain = "vpc"
  tags = {
    Name      = "${var.vpc_name}_eip"
    CreatedBy = "usama ali"
  }
}

resource "aws_subnet" "rke2_public" {
  vpc_id            = aws_vpc.rke2_vpc.id
  cidr_block        = "10.0.0.0/18"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name      = var.pub_subnet_name
    CreatedBy = "usama ali"
  }
}

resource "aws_nat_gateway" "rke2_ngw" {
  allocation_id = aws_eip.rke2_eip.id
  subnet_id     = aws_subnet.rke2_public.id

  tags = {
    Name = "${var.vpc_name}_ngw"
    CreatedBy = "usama ali"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.rke2_igw]
}


resource "aws_route_table" "rke2_public_rt" {
  vpc_id = aws_vpc.rke2_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rke2_igw.id
  }
  tags = {
    Name = "${var.pub_subnet_name}_rt"
    CreatedBy = "usama ali"
  }
}

resource "aws_route_table_association" "rke2_public_rt_asso" {
  subnet_id      = aws_subnet.rke2_public.id
  route_table_id = aws_route_table.rke2_public_rt.id
}


resource "aws_route_table" "rke2_private_rt" {
  vpc_id = aws_vpc.rke2_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.rke2_ngw.id
  }
  tags = {
    Name = "${var.priv_subnet_name}_rt"
    CreatedBy = "usama ali"
  }
}

resource "aws_subnet" "rke2_private" {
  for_each = {
    ap-southeast-1a = "10.0.64.0/18"
    ap-southeast-1b = "10.0.128.0/18"
    ap-southeast-1c = "10.0.192.0/18"
  }
  vpc_id            = aws_vpc.rke2_vpc.id
  cidr_block        = each.value
  availability_zone = each.key


  tags = {
    Name      = var.priv_subnet_name
    CreatedBy = "usama ali"
  }
}

resource "aws_route_table_association" "rke2_private_rt_asso" {
  for_each       = aws_subnet.rke2_private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.rke2_private_rt.id
}