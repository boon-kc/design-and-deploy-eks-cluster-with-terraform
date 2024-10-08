# IAM role for worker nodes
resource "aws_iam_role" "eks_worker_role" {
  name = "eks_worker_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach necessary policies to worker nodes
resource "aws_iam_role_policy_attachment" "worker_node_AmazonEKSWorkerNodePolicy" {
  role = aws_iam_role.eks_worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "worker_node_cni_policy" {
  role = aws_iam_role.eks_worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# IAM Instance Profile for Worker Nodes 
resource "aws_iam_instance_profile" "eks_worker_profile" {
  name = "eks_worker_profile"
  role = aws_iam_role.eks_worker_role.name
}

# IAM Policy for EBS Storage
resource "aws_iam_policy" "ebs_access_policy" {
  name = "ebs_access_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2: AttachVolume",
          "ec2: DetachVolume",
          "ec2: CreateVolume",
          "ec2: DeleteVolume",
          "ec2: DescribeVolume",
          "ec2: DescribeVolumeStatus",
          "ec2: ModifyVolume",
          "ec2: DescribeInstances",
          "ec2: DescribeInstancesStatus",
          "ec2: CreateSnapshot",
          "ec2: DeleteSnapshot",
          "ec2: DescribeSnapshots",
          "ec2: DescribeTags",
          "ec2: DescribeAvailabilityZones",
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "worker_node_ebs_acccess_policy" {
  role = aws_iam_role.eks_worker_role.name
  policy_arn = aws_iam_policy.ebs_access_policy.arn
}

# IAM policy to interact with CloudWatch, and other AWS services such as accessing S3.
resource "aws_iam_policy" "eks_cluster_policy" {
  name = "EKS-Cluster-Policy"
  description = "IAM policy to allow EKS cluster to interact with AWS services like CloudWatch and S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups",
        ]
        Resource = "*"
      }, 
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "cloudwatch:GetMetricData",
          "cloudwatch:ListMetrics",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:DescribeAlarmsHistory",
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_eks_cluster_policy" {
  role = aws_iam_role.eks_worker_role.name
  policy_arn = aws_iam_policy.eks_cluster_policy.arn
}
