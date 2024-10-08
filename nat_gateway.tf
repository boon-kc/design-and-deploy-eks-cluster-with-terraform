# resource "aws_eip" "eip_for_nat_gateway_az1" {
#   vpc = true
#   tags = {
#     Name = "nat gateway"
#   }
# }

# resource "aws_eip" "eip_for_nat_gateway_az2" {
#   vpc = true
#   tags = {
#     Name = "nat gateway"
#   }
# }

# resource "aws_nat_gateway" "eks_nat_gatway_az1" {
#   allocation_id = aws_eip.nat.id
#   subnet_id = module.vpc.public_subnets[0]
# }

# resource "aws_nat_gateway" "eks_nat_gatway_az2" {
#   allocation_id = aws_eip.nat.id
#   subnet_id = module.vpc.public_subnets[1]
# }