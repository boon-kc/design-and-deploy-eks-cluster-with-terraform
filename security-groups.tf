# Security Group for EKS Control Plane
resource "aws_security_group" "eks_control_plane_sg" {
  name   = "eks-control-plane-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Allow only within the VPC range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic to any destination
  }
  tags = {
    Name = "eks-control-plane-sg"
  }
}

# Security Group for Worker Nodes
resource "aws_security_group" "eks_worker_sg" {
  name   = "eks-worker-sg"
  vpc_id = module.vpc.vpc_id

  # Allow traffic between worker nodes and EKS control plane
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Allow traffic within VPC
  }

  # Allow traffic for worker nodes to communicate with each other
  ingress {
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Allow traffic within VPC
  }

  # Allow traffic for the kubelet API
  ingress {
    from_port = 10250
    to_port = 10250
    protocol = "tcp"
    cidr_blocks =  ["10.0.0.0/16"] # Kubelet API communication
  }

  # Outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
  
  tags = {
    Name = "eks-worker-sg"
  }
}