output "iam_policy_external_dns" {
  value = resource.aws_iam_policy.external_dns.arn
}

output "iam_policy_cluster_autoscaler" {
  value = resource.aws_iam_policy.autoscaler.arn
}

output "iam_policy_alb_controller" {
  value = resource.aws_iam_policy.alb.arn
}
