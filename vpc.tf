module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name = "eks-vpc"
  cidr = var.vpc_cidr # an IP address range defining number of internal network addresses that can be used within a VPC, total 65,536 possible addresses

  azs = var.availability_zones # Two availability zones
  private_subnets = var.private_subnet_cidrs
  public_subnets = var.public_subnet_cidrs

  enable_nat_gateway = true # private subnet will need go through public subnet to access the internet
  single_nat_gateway = false
  one_nat_gateway_per_az = true

  enable_dns_support = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    Name = "eks-public-subnet"
  }

  private_subnet_tags = {
    Name = "eks-private-subnet"
  }

  tags = {
    Name = "eks-vpc"
  }
}