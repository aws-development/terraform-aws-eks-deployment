variable "name_prefix" {
  type        = string
  description = "Name prefix used across resources created by this module."
}

variable "env" {
  type        = string
  description = "Environment used across resources created by this module."
  default     = "dev"
}

variable "AWS_ACCESS_KEY" {
  type = string
}
variable "AWS_SECRET_KEY" {
  type = string
}

variable "REGION" {
  type        = string
  description = "AWS region used across resources created by this module."
  default     = "ap-southeast-1"
}


variable "project" {
  type        = string
  description = "Name prefix used across resources created by this module."
  default     = "eks-poc"
}

#####
# VPC
#####
variable "vpc_cidr" {
  type        = string
  description = "Amazon Virtual Private Cloud Classless Inter-Domain Routing range."
}

variable "private_subnets_cidrs" {
  type        = list(string)
  description = "Classless Inter-Domain Routing ranges for private subnets."
}

variable "public_subnets_cidrs" {
  type        = list(string)
  description = "Classless Inter-Domain Routing ranges for public subnets."
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

#####
# EKS
#####
variable "eks_version" {
  type        = string
  description = "EKS controlplane version."
}

variable "eks_enabled_log_types" {
  description = "List of the desired control plane logging to enable."
  type        = list(string)
  default     = []
}

variable "instance_types" {
  type        = list(string)
  description = "List of instance types associated with the EKS Node Group."
  default     = ["t2.medium"]
}

variable "eks_service_ipv4_cidr" {
  type        = string
  description = "The CIDR block to assign Kubernetes service IP addresses from."
  default     = null
}

variable "eks_public_access_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks. Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled."
  default     = ["49.36.144.72/32"]
}

variable "eks_security_group_ids" {
  type        = list(string)
  description = "List of security group IDs for the cross-account elastic network interfaces that Amazon EKS creates to use to allow communication between your worker nodes and the Kubernetes control plane."
  default     = []
}

variable "eks_endpoint_private_access" {
  type        = bool
  description = "Whether the Amazon EKS private API server endpoint is enabled."
  default     = true
}

variable "eks_endpoint_public_access" {
  type        = bool
  description = "Whether the Amazon EKS public API server endpoint is enabled."
  default     = false
}

#####
# EKS Addons
#####
variable "eks_addon_version_kube_proxy" {
  type        = string
  description = "Kube proxy managed EKS addon version."
  default     = null
}

variable "eks_addon_version_core_dns" {
  type        = string
  description = "Core DNS managed EKS addon version."
  default     = null
}

variable "eks_addon_version_ebs_csi_driver" {
  type        = string
  description = "AWS ebs csi driver managed EKS addon version."
  default     = null
}

variable "eks_addon_version_kubecost" {
  type        = string
  description = "KubeCost EKS addon version."
  default     = null
}

variable "eks_addon_version_guardduty" {
  type        = string
  description = "Guardduty agent EKS addon version."
  default     = null
}

variable "eks_addon_version_adot" {
  type        = string
  description = "ADOT EKS addon version."
  default     = null
}

variable "eks_addon_version_cloudwatch" {
  type        = string
  description = "Cloudwatch EKS addon version."
  default     = null
}

#####
# EKS Default Managed Node Group
#####
variable "ebs_delete_on_termination" {
  type        = bool
  description = "Whether the volume should be destroyed on instance termination."
  default     = true
}

variable "ebs_volume_size" {
  type        = number
  description = "The size of the volume in gigabytes."
  default     = 20
}

variable "ebs_volume_type" {
  type        = string
  description = "The volume type."
  default     = "gp3"
}

variable "ebs_encrypted" {
  type        = bool
  description = "Enables EBS encryption on the volume."
  default     = true
}


## vars for kubectl server##

variable "instance_count" {
  type    = number
  default = 1
}

variable "ami_id" {
  type    = string
  default = "ami-0e4b5d31e60aa0acd"
}

variable "instance_type" {
  type    = string
  default = "t2.medium"
}

variable "key_name" {
  type    = string
  default = "kubectl-key"
}


variable "features" {
  description = "Feature toggle options"
  type        = map(bool)
  default = {
    diskfull = true
    cwagent  = true
    envoy    = true
  }
}


##alb controller helm chart variables  ###

variable "alb_controller_enabled" {
  type        = bool
  default     = true
  description = "Variable indicating whether deployment is enabled."
}


variable "alb_controller_service_account_name" {
  type        = string
  default     = "aws-load-balancer-controller"
  description = "ALB Controller service account name"
}

variable "alb_controller_helm_chart_name" {
  type        = string
  default     = "aws-load-balancer-controller"
  description = "ALB Controller Helm chart name to be installed"
}

variable "alb_controller_helm_chart_release_name" {
  type        = string
  default     = "aws-load-balancer-controller"
  description = "Helm release name"
}

variable "alb_controller_helm_chart_version" {
  type        = string
  default     = "1.6.1"
  description = "ALB Controller Helm chart version."
}

variable "alb_controller_helm_chart_repo" {
  type        = string
  default     = "https://aws.github.io/eks-charts"
  description = "ALB Controller repository name."
}

variable "alb_controller_namespace" {
  type        = string
  default     = "kube-system"
  description = "Kubernetes namespace to deploy ALB Controller Helm chart."
}

variable "alb_controller_mod_dependency" {
  default     = null
  description = "Dependence variable binds all AWS resources allocated by this module, dependent modules reference this variable."
}

variable "alb_controller_settings" {
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values."
}



###wiz eks connector variables

variable "wiz_image_path" {
  type    = string
  default = "wiziopublic.azurecr.io/wiz-app/wiz-broker:2.4"
}


variable "wiz_env" {
  type    = string
  default = ""
}

variable "wiz_namespace" {
  type    = string
  default = "wiz"
}

variable "wiz_connector_name" {
  type    = string
  default = "wiz-eks-ap-dev-poc-connector"
}

variable "wiz_server_endpoint" {
  type    = string
  default = "https://kubernetes.default.svc.cluster.local"
}

variable "wiz_connector_type" {
  type    = string
  default = "eks"
}

variable "wiz_is_private" {
  type    = bool
  default = true
}


variable "wiz_url" {
  type    = string
  default = "https://api.us34.app.wiz.io/graphql"
}

variable "wiz_auth_client_id" {
  type = string
}

variable "wiz_auth_client_secret" {
  type      = string
  sensitive = true
}

variable "wiz_auth_audience" {
  type    = string
  default = "beyond-api"
}

variable "wiz_auth_url" {
  type    = string
  default = "https://auth.app.wiz.io/oauth/token"
}

variable "wiz_broker_client_id" {
  type    = string
  default = ""
}

variable "wiz_broker_client_secret" {
  type      = string
  sensitive = true
  default   = ""
}

#variables for wiz runtime sensor

variable "wiz_install_runtime_sensor" {
  type    = bool
  default = true
}


variable "wiz_runtime_sensor_helm_chart_name" {
  type    = string
  default = "wiz-sensor"
  description = "Wiz runtime sensor helm chart name"
}


variable "wiz_runtime_sensor_helm_chart_release_name" {
  type    = string
  default = "wiz-sensor-release"
  description = "Wiz runtime sensor helm chart release name"
}

variable "wiz_runtime_sensor_helm_chart_repo" {
  type    = string
  default = "https://charts.wiz.io/"
  description = "Wiz runtime sensor helm chart repo"
}

variable "wiz_runtime_sensor_helm_chart_version" {
  type    = string
  default = "1.0.3011"
  description = "Wiz runtime sensor helm chart version"
}


variable "wiz_registry_username" {
  type    = string
  default = ""
  description = "Wiz registry username"
}

variable "wiz_registry_password" {
  type    = string
  default = ""
  sensitive = true
  description = "Wiz registry password"
}

variable "wiz_runtime_sensor_sa_secret_id" {
  type    = string
  default = ""
  description = "Wiz runtime sensor service account secret id"
}

variable "wiz_runtime_sensor_sa_secret_key" {
  type    = string
  default = ""
  sensitive = true
  description = "Wiz runtime sensor service account secret key"
}
