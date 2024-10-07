# Internet Gateway for public subnets to route outbound traffic
resource "aws_internet_gateway" "igw" {
  vpc_id = module.vpc.vpc_id
  tags = {
    Name = "eks-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0" # All internet traffic
    gateway_id = aws_internet_gateway.igw.id # Internet Gateway ID
  }

  tags = {
    Name = "eks-public-route-table"
  }
}


# Associate public subnets with Public Poute Table
resource "aws_route_table_association" "public_subnet_a" {
  subnet_id = element(module.vpc.public_subnets, 0)
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_b" {
  subnet_id = element(module.vpc.public_subnets, 1)
  route_table_id = aws_route_table.public_route_table.id
}

# Private Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block = "10.0.0.0/16" # Local VPC communication
    gateway_id = "local"
  }

  tags = {
    Name = "eks-private-route-table"
  }
}

# Associate private subnets with Private Route Table
resource "aws_route_table_association" "private_subnet_a" {
  subnet_id = element(module.vpc.private_subnets, 0)
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_b" {
  subnet_id = element(module.vpc.private_subnets, 1)
  route_table_id = aws_route_table.private_route_table.id
}