variable "aws_region" {
  default = "us-east-1"
}

variable "cluster-name" {
  default = "terraform-eks-stage"
  type    = string
}

variable "eks_node_instance_type" {
  default = "t2.medium"
}
