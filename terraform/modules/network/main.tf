resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.1.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "eks-vpc"
  }
}

resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "eks-igw"
  }
}

resource "aws_route_table" "eks_public_route_table" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }

  tags = {
    Name = "eks-public-route-table"
  }
}

resource "aws_subnet" "eks_public_subnet" {
  for_each = { for i, az in var.availability_zones : az => var.public_subnets[i] }

  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name = "eks-public-subnet-${each.key}"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_route_table_association" "eks_route_table_assoc" {
  for_each = aws_subnet.eks_public_subnet

  subnet_id      = each.value.id
  route_table_id = aws_route_table.eks_public_route_table.id
}

