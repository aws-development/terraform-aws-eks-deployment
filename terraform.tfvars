name_prefix = "wiz-eks-ap-dev-poc"

vpc_cidr              = "10.100.0.0/16"
private_subnets_cidrs = ["10.100.0.0/18", "10.100.64.0/18", "10.100.128.0/18"]
public_subnets_cidrs  = ["10.100.192.0/20", "10.100.208.0/20", "10.100.224.0/20"]
azs                   = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
#private_subnets_cidrs = ["10.100.0.0/18", "10.100.64.0/18"]
#public_subnets_cidrs  = ["10.100.192.0/20", "10.100.208.0/20"]
#azs                   = ["ap-southeast-1a", "ap-southeast-1b"]

eks_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
eks_service_ipv4_cidr = "10.190.0.0/16"

instance_types = ["t2.medium"]

eks_public_access_cidrs = [
  "49.36.144.140/32"
]

eks_version = "1.28"

eks_addon_version_kube_proxy     = "v1.28.2-eksbuild.2"
eks_addon_version_core_dns       = "v1.10.1-eksbuild.5"
eks_addon_version_ebs_csi_driver = "v1.25.0-eksbuild.1"
#eks_addon_version_kubecost      = "v1.103.3-eksbuild.0"
eks_addon_version_guardduty  = "v1.3.1-eksbuild.1"
eks_addon_version_cloudwatch = "v1.1.1-eksbuild.1"
