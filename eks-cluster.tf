module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "20.24.3"

  cluster_name = "my-eks-cluster"
  cluster_version = "1.29"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  enable_irsa = true

  eks_managed_node_group_defaults = {
    disk_size = 50
  }

  # Worker node configuration
  eks_managed_node_groups = {
    eks_managed_workers = {
      name = "managed-node-group"
      min_size = 2
      max_size = 4
      desired_size = 2
      instance_type = "t3.small"
      subnet_ids = module.vpc.private_subnets
      capacity_type = "ON_DEMAND"
    }
  }

  tags = {
    Environment = "dev"
    Terraform = "true"
  }
}