resource "aws_network_acl" "private_nacl" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "private-nacl"
  }
}

# Allow inbound traffic from VPC (control plane, EBS, etc)
resource "aws_network_acl_rule" "allow_internal_inbound" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number = 100
  egress = false
  protocol = "-1" # All protocols
  cidr_block = module.vpc.vpc_cidr_block # VPC CIDR for internal traffic
  rule_action = "allow"
  from_port = 0
  to_port = 0
}

# Allow outbound traffic to VPC (EBS, control plane, etc)
# resource "aws_network_acl_rule" "allow_internal_outbound" {
#   network_acl_id = aws_network_acl.private_nacl.id
#   rule_number = 100
#   egress = true
#   protocol = "-1" # All protocols
#   cidr_block = module.vpc.vpc_cidr_block # VPC CIDR for internal traffic
#   rule_action = "allow"
#   from_port = 0
#   to_port = 0
# }

# Allow all inbound traffic from the NAT
resource "aws_network_acl_rule" "allow_internet_inbound" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number = 200 # higher priority for allow rule
  egress = false
  protocol = "-1" # All protocols
  cidr_block = "0.0.0.0/0" # Internet
  rule_action = "allow"
  from_port = 0
  to_port = 0
}

# Deny all outbound traffic to the internet 
resource "aws_network_acl_rule" "deny_internet_outbound" {
  network_acl_id = aws_network_acl.private_nacl.id
  rule_number = 100
  egress = true
  protocol = "-1" # All protocols
  cidr_block = "0.0.0.0/0" # Internet
  rule_action = "allow"
  from_port = 0
  to_port = 0
}

# Associate Network Access Control List with private subnets
resource "aws_network_acl_association" "private_nacl_assoc_1" {
  network_acl_id = aws_network_acl.private_nacl.id
  subnet_id = module.vpc.private_subnets[0]
}

resource "aws_network_acl_association" "private_nacl_assoc_2" {
  network_acl_id = aws_network_acl.private_nacl.id
  subnet_id = module.vpc.private_subnets[1]
}
