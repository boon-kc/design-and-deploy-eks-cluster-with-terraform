variable "region" {
  description = "AWS deployment region"
  default = "ap-southeast-1"
}

variable "availability_zones" {
  description = "List of availability zones to use"
  default = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of public subnets' CIDR blocks"
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of private subnets' CIDR blocks"
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}
