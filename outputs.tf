output "cluster_name" {
  description = "Nome do cluster EKS"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "Endpoint da API do Kubernetes"
  value       = aws_eks_cluster.main.endpoint
}

resource "local_file" "kubeconfig" {
  content = <<-EOT
    apiVersion: v1
    clusters:
    - cluster:
        server: ${aws_eks_cluster.main.endpoint}
        certificate-authority-data: ${aws_eks_cluster.main.certificate_authority[0].data}
      name: ${aws_eks_cluster.main.name}
    contexts:
    - context:
        cluster: ${aws_eks_cluster.main.name}
        user: ${aws_eks_cluster.main.name}
      name: ${aws_eks_cluster.main.name}
    current-context: ${aws_eks_cluster.main.name}
    kind: Config
    preferences: {}
    users:
    - name: ${aws_eks_cluster.main.name}
      user:
        exec:
          apiVersion: client.authentication.k8s.io/v1beta1
          command: aws
          args:
            - "eks"
            - "get-token"
            - "--cluster-name"
            - "${aws_eks_cluster.main.name}"
            - "--profile"
            - "${var.aws_profile}"
  EOT
  filename = "${path.module}/kubeconfig.yaml"
}