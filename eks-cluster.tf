module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "20.24.3"

  cluster_name = "my-eks-cluster"
  cluster_version = "1.29"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true

  cluster_additional_security_group_ids = [aws_security_group.eks_control_plane_sg.id, aws_security_group.eks_worker_sg.id]

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  enable_irsa = true

  eks_managed_node_group_defaults = {
    disk_size = 50
  }

  # Worker nodes configuration
  eks_managed_node_groups = {
    eks_managed_worker = {
      name = "managed-node-group-1"
      min_size = 2
      max_size = 2
      desired_size = 2
      instance_type = "t3.small"
      subnet_ids = [module.vpc.private_subnets[0]]
      capacity_type = "ON_DEMAND"
    },
      eks_managed_worker_2 = {
      name = "managed-node-group-2"
      min_size = 1
      max_size = 1
      desired_size = 1
      instance_type = "t3.small"
      subnet_ids = [module.vpc.private_subnets[1]]
      capacity_type = "ON_DEMAND"
    }
  }

  tags = {
    Environment = "dev"
    Terraform = "true"
  }
}