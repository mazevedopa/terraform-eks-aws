variable "aws_region" {
  description = "Região da AWS para criar os recursos"
  type        = string
  default     = "us-west-2"
}

variable "aws_profile" {
  description = "Perfil de credenciais da AWS"
  type        = string
  default     = "AWS-MARCOSAZEVEDO"
}

variable "cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
  default     = "libnet-eks-prod"
}

variable "instance_type" {
  description = "Tipo de instância para os nós do EKS"
  type        = string
  default     = "t3.medium"
}

variable "vpc_cidr" {
  description = "Bloco CIDR para a VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  description = "Blocos CIDR para as subnets públicas"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidr" {
  description = "Blocos CIDR para as subnets privadas"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}
