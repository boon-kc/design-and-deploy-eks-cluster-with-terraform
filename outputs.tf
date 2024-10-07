output "eks_cluster_name" {
  value = module.eks.cluster_id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_worker_role_arn" {
  value = aws_iam_role.eks_worker_role.arn
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "worker_node_security_group" {
  value = module.eks.node_security_group_id
}
