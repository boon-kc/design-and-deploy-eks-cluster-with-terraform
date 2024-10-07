resource "aws_ebs_volume" "eks_volume" {
  availability_zone = "ap-southeast-1a"
  size = 20 # 20 GB volume size
  type = "gp2"

  tags = {
    Name = "aws-ebs-storage"
  }
}