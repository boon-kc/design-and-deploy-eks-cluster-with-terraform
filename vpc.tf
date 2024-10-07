module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name = "eks-vpc"
  cidr = "10.0.0.0/16" # an IP address range defining number of internal network addresses that can be used within a VPC, total 65,536 possible addresses

  azs = ["ap-southeast-1a", "ap-southeast-1b"] # Two availability zones
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = false # private subnet will need go through public subnet to access the internet

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