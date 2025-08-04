resource "aws_security_group" "eks_cluster" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "Security group for the EKS control plane."
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.cluster_name}-cluster-sg"
  }
}

resource "aws_security_group" "eks_nodes" {
  name        = "${var.cluster_name}-node-sg"
  description = "Security group for the EKS worker nodes."
  vpc_id      = aws_vpc.main.id

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-node-sg"
  }
}

# Allow worker nodes to communicate with the control plane
resource "aws_security_group_rule" "cluster_ingress_from_nodes" {
  description              = "Allow nodes to communicate with the control plane (HTTPS)"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
}

# Allow control plane to communicate with worker nodes
resource "aws_security_group_rule" "nodes_ingress_from_cluster" {
  description              = "Allow control plane to communicate with nodes"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_cluster.id
}

# Allow nodes to communicate with each other
resource "aws_security_group_rule" "nodes_ingress_self" {
  description              = "Allow nodes to communicate with each other"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_nodes.id
}