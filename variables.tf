variable "AWS_ACCESS_KEY" {
  type = string
}
variable "AWS_SECRET_KEY" {
  type = string
}
variable "REGION" {
  type    = string
  default = "us-east-1"
}


variable "lob" {
  type        = string
  default     = "eks"
  description = "lob tag"
}

variable "tf_provider" {
  type        = string
  default     = "aws"
  description = "provider tag"
}

variable "env" {
  type        = string
  default     = "dev"
  description = "env tag"
}

variable "platform" {
  type        = string
  default     = "eks"
  description = "platform tag"
}

variable "application" {
  type        = string
  default     = "dev-app"
  description = "application tag"
}

variable "cost_center" {
  type        = string
  default     = "aws-cc"
  description = "cost_center tag"
}

variable "owner" {
  type        = string
  default     = "ravikumar"
  description = "owner tag"
}

variable "project" {
  type        = string
  default     = "aws-eks-poc"
  description = "project tag"
}

variable "developer" {
  type        = string
  default     = "ravikumar"
  description = "developer name"
}

variable "eks_cluster_version" {
  type        = string
  default     = "1.28"
  description = "eks_cluster_version"
}

variable "eks_worker_node_instance_type" {
  type        = string
  default     = "t2.micro"
  description = "eks_worker_node_instance_type"
}

variable "min_worker_node" {
  type        = string
  default     = "1"
  description = "min_worker_node"
}

variable "max_worker_node" {
  type        = string
  default     = "1"
  description = "min_worker_node"
}

variable "spot_allocation_strategy" {
  type        = string
  default     = "lowest-price"
  description = "spot_allocation_strategy"
}
