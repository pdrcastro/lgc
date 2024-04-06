# === EKS Cluster-Autoscaler Policy ===
data "template_file" "eks_cluster_autoscaler" {
  template = file("templates/iam-policy-eks-cluster-autoscaler.json")
}

resource "aws_iam_policy" "autoscaler" {
  name        = "Eks-ClusterAutoscaler-${var.environment}"
  path        = "/"
  description = "EKS Cluster Autoscaler policy"
  policy      = data.template_file.eks_cluster_autoscaler.rendered
}