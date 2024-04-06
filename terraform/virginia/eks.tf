data "template_file" "pre_userdata_workers_eks" {
  template = file("templates/pre_userdata_workers_eks")
}


data "aws_ssm_parameter" "eks_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${var.worker_node_version}/amazon-linux-2/recommended/release_version"
}

# EKS Module
module "eks_cluster" {
  source                                 = "terraform-aws-modules/eks/aws"
  version                                = "~> 19.13"
  cluster_name                           = "eks-${var.environment}-${var.datacenter}"
  cluster_version                        = var.cluster_version
  vpc_id                                 = local.vpc_id
  subnet_ids                             = local.subnet_ids_private
  enable_irsa                            = true #default true
  create_kms_key                         = false
  attach_cluster_encryption_policy       = false
  cluster_encryption_config              = {}    #to KMS disable
  cluster_endpoint_private_access        = false  #default true
  cluster_endpoint_public_access         = true #default false
  cluster_enabled_log_types              = []
  cloudwatch_log_group_retention_in_days = 30
  create_cloudwatch_log_group = false

# This was to try access from internet
  # cluster_security_group_additional_rules = {
  #   ingress_prefixlist = {
  #     description     = "Allow Traffic to worker Nodes"
  #     protocol        = "-1"
  #     from_port       = 0
  #     to_port         = 0
  #     type            = "ingress"
  #     cidr_blocks     = local.access_worker_nodes
  #   }
  # }

  # EKS AddOns
  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
      addon_version     = var.coredns_version
    }
    kube-proxy = {
      resolve_conflicts = "OVERWRITE"
      addon_version     = var.kubeproxy_version
    }
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
      addon_version     = var.vpccni_version
    }
  }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    disk_size              = 20
    key_name               = "kube"
    create_launch_template = true
    create_iam_role        = true #default true
    cluster_version        = var.worker_node_version
    iam_role_additional_policies = {
       external_dns       = data.terraform_remote_state.global.outputs.iam_policy_external_dns
       cluster_autoscaler = data.terraform_remote_state.global.outputs.iam_policy_cluster_autoscaler
       alb_controller     = data.terraform_remote_state.global.outputs.iam_policy_alb_controller
    }
  }

  eks_managed_node_groups = {
    eks_worker_node_mng = {
      min_size                = 1
      max_size                = 3
      desired_size            = 1
      ami_release_version     = nonsensitive(data.aws_ssm_parameter.eks_ami_release_version.value)
      instance_types          = ["c3.2xlarge", "c4.2xlarge", "c5.2xlarge", "c5a.2xlarge", "t3.xlarge"]
      capacity_type           = "SPOT" # or "ON_DEMAND"
      pre_bootstrap_user_data = data.template_file.pre_userdata_workers_eks.rendered
      update_config = {
        max_unavailable_percentage = 33
      }
    }
  }

  ## to create without in the first moment
  node_security_group_additional_rules = {
    node_groups_all = {
      description = "Allow all TCP between nodes"
      protocol    = "tcp"
      from_port   = 0
      to_port     = 65535
      type        = "ingress"
      self        = true
    }
    ingress_alb_balancer_http = {
      description              = "Allow ALB Ingress HTTP"
      protocol                 = "tcp"
      from_port                = 80
      to_port                  = 80
      type                     = "ingress"
      source_security_group_id = resource.aws_security_group.interview.id
    }
    ingress_alb_balancer_https = {
      description              = "Allow ALB Ingress HTTP"
      protocol                 = "tcp"
      from_port                = 443
      to_port                  = 443
      type                     = "ingress"
      source_security_group_id = resource.aws_security_group.interview.id
    }
    ingress_alb_balancer_apps = {
      description              = "Allow ALB Ingress HTTP"
      protocol                 = "tcp"
      from_port                = 1000
      to_port                  = 65535
      type                     = "ingress"
      source_security_group_id = resource.aws_security_group.interview.id
    }
  }


  # aws-auth configmap
  manage_aws_auth_configmap = false

  tags = {
    ClusterName       = "eks-${var.environment}-${var.datacenter}"
    SourceModule      = "terraform-aws-modules/eks/aws"
  }
}
