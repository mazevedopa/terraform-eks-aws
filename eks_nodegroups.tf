resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-nodegroup-1"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = [for subnet in aws_subnet.private : subnet.id]

  instance_types = [var.instance_type]
  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_container_registry_read_only,
  ]

  tags = {
    Name = "${var.cluster_name}-nodegroup-1"
  }
}

resource "aws_eks_node_group" "secondary" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-nodegroup-2"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = [for subnet in aws_subnet.private : subnet.id]

  instance_types = [var.instance_type]
  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_container_registry_read_only,
  ]

  tags = {
    Name = "${var.cluster_name}-nodegroup-2"
  }
}