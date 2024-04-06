data "template_file" "role_policy_external_dns" {
  template = file("templates/iam-policy-route53-admin.json")
}

resource "aws_iam_policy" "external_dns" {
  name        = "ExternalDNSAdminAccess-${var.environment}"
  path        = "/"
  description = "Policy Admin permission for External DNS"
  policy      = data.template_file.role_policy_external_dns.rendered 
}