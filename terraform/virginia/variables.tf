#########
#General#
#########

variable "region" {
    default = "us-east-1"
}

variable "datacenter" {
  default = "virginia"
}

variable "environment" {
  default = "interview"
}

#####
#EKS#
#####

variable "worker_node_version" {
  default = "1.28"
}

variable "cluster_version" {
  default = "1.28"
}

variable "coredns_version" {
  default = "v1.10.1-eksbuild.7"
}

variable "kubeproxy_version" {
  default = "v1.28.4-eksbuild.4"
}

variable "vpccni_version" {
    default = "v1.16.2-eksbuild.1"
}

#########
#Route53#
#########

variable "zone_id" {
  default = "Z03053682A3A8U0MLV0TA"
}