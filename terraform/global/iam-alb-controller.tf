# === IAM - Policy to permite correct access for External DNS === ### 
data "template_file" "role_policy_alb_controller" {
  template = file("templates/iam-policy-alb-controller.json")
}

resource "aws_iam_policy" "alb" {
  name        = "ALBControllerAdminAccess-${var.environment}"
  path        = "/"
  description = "Policy Admin permission for ALB Controller"
  policy      = data.template_file.role_policy_alb_controller.rendered  
}