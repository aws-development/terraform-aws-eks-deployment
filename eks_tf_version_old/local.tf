locals {
  env     = terraform.workspace
  project = var.project
  dev     = var.developer
  common_tags = {
    Environment = local.env
    Owner       = local.dev
    Project     = local.project
  }
  tf_vpc_ipblock = {
    dev  = "10.145.0.0/16"
    prod = "10.145.16.0/16"
    uat  = "10.145.32.0/16"
  }
  vpc_ipblock = local.tf_vpc_ipblock[local.env]

  tf_public_subnet_1a = {
    dev  = "10.145.0.0/24"
    prod = "10.145.16.0/24"
    uat  = "10.145.32.0/24"
  }
  public_subnet_1a = local.tf_public_subnet_1a[local.env]

  tf_public_subnet_1b = {
    dev  = "10.145.1.0/24"
    prod = "10.145.17.0/24"
    uat  = "10.145.33.0/24"
  }

  public_subnet_1b = local.tf_public_subnet_1b[local.env]

  tf_public_subnet_1c = {
    dev  = "10.145.2.0/24"
    prod = "10.145.18.0/24"
    uat  = "10.145.34.0/24"
  }
  public_subnet_1c = local.tf_public_subnet_1c[local.env]

  tf_private_subnet_1a = {
    dev  = "10.145.4.0/24"
    prod = "10.145.20.0/24"
    uat  = "10.145.36.0/24"
  }
  private_subnet_1a = local.tf_private_subnet_1a[local.env]
  tf_private_subnet_1b = {
    dev  = "10.145.5.0/24"
    prod = "10.145.21.0/24"
    uat  = "10.145.37.0/24"
  }
  private_subnet_1b = local.tf_private_subnet_1b[local.env]
  tf_private_subnet_1c = {
    dev  = "10.145.6.0/24"
    prod = "10.145.22.0/24"
    uat  = "10.145.38.0/24"
  }
  private_subnet_1c = local.tf_private_subnet_1c[local.env]



  eks_cluster_name = "${local.env}_${local.project}_eks_cluster"
  tf_k8_version = {
    uat  = var.eks_cluster_version
    prod = var.eks_cluster_version
    dev  = var.eks_cluster_version
  }
  eks_node_group_name = "${local.env}_${local.project}_eks_cluster_ng"


  k8_version = local.tf_k8_version[local.env]

  tf_eks_worker_node_instance_type = {
    uat  = var.eks_worker_node_instance_type
    prod = var.eks_worker_node_instance_type
    dev  = var.eks_worker_node_instance_type
  }
  eks_worker_node_instance_type = local.tf_eks_worker_node_instance_type[local.env]

  tf_eks_worker_node_userdata = {
    uat  = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks.certificate_authority[0].data}' '${aws_eks_cluster.eks.name}'
USERDATA
    prod = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks.certificate_authority[0].data}' '${aws_eks_cluster.eks.name}'
USERDATA
    dev  = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks.certificate_authority[0].data}' '${aws_eks_cluster.eks.name}'
USERDATA
  }
  eks_worker_node_userdata = local.tf_eks_worker_node_userdata[local.env]

  tf_eks_worker_node_keypair = {
    uat  = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAj6aF5unZBN1Emq8D4Jhddi5/YmBBkxx0md6pO5xZPZ7aPSDPng4d1n6dkGU1mE1ZSzT/ttGfZOPd0AWYGxEa5Hce1FHPv3zcJy8JFC/mxjeXRVRTX01mphvk5GT/3JqP5qSzPynkS6p15GIIq26Mr8AXOmmSwCYqVY+c52L1sogQtxL+KC9/kKqjYYTdWUOMZ6bIKtnobYtix3P+E/dkuQInytgjrie8tSs1CNZ1cKikma231MdWJhlQCrgLdINd15cOskSJoy/ti3FEK0PONmjEyJm84Yl77v7f8hJPjASQ9ZmtRFQ0LedFBgmwmCGhInAHtErVIU1Ng2+GpVs0mw=="
    prod = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAj6aF5unZBN1Emq8D4Jhddi5/YmBBkxx0md6pO5xZPZ7aPSDPng4d1n6dkGU1mE1ZSzT/ttGfZOPd0AWYGxEa5Hce1FHPv3zcJy8JFC/mxjeXRVRTX01mphvk5GT/3JqP5qSzPynkS6p15GIIq26Mr8AXOmmSwCYqVY+c52L1sogQtxL+KC9/kKqjYYTdWUOMZ6bIKtnobYtix3P+E/dkuQInytgjrie8tSs1CNZ1cKikma231MdWJhlQCrgLdINd15cOskSJoy/ti3FEK0PONmjEyJm84Yl77v7f8hJPjASQ9ZmtRFQ0LedFBgmwmCGhInAHtErVIU1Ng2+GpVs0mw=="
    dev  = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAj6aF5unZBN1Emq8D4Jhddi5/YmBBkxx0md6pO5xZPZ7aPSDPng4d1n6dkGU1mE1ZSzT/ttGfZOPd0AWYGxEa5Hce1FHPv3zcJy8JFC/mxjeXRVRTX01mphvk5GT/3JqP5qSzPynkS6p15GIIq26Mr8AXOmmSwCYqVY+c52L1sogQtxL+KC9/kKqjYYTdWUOMZ6bIKtnobYtix3P+E/dkuQInytgjrie8tSs1CNZ1cKikma231MdWJhlQCrgLdINd15cOskSJoy/ti3FEK0PONmjEyJm84Yl77v7f8hJPjASQ9ZmtRFQ0LedFBgmwmCGhInAHtErVIU1Ng2+GpVs0mw=="
  }
  eks_worker_node_keypair = local.tf_eks_worker_node_keypair[local.env]

  tf_min_worker_node = {
    uat  = var.min_worker_node
    prod = var.min_worker_node
    dev  = var.min_worker_node
  }
  min_worker_node = local.tf_min_worker_node[local.env]

  tf_max_worker_node = {
    uat  = var.max_worker_node
    prod = var.max_worker_node
    dev  = var.max_worker_node
  }
  max_worker_node = local.tf_max_worker_node[local.env]

  tf_asg_mixed_instance_types = {
    uat = [
      { name = "t3.large", weight = "1" },
      { name = "t3a.large", weight = "1" }
    ]
    prod = [
      { name = "t2.medium", weight = "1" },
      { name = "t2.small", weight = "1" }
    ]
    dev = [
      { name = "t2.medium", weight = "1" },
      { name = "t2.small", weight = "1" }
    ]
  }
  asg_mixed_instance_types = local.tf_asg_mixed_instance_types[local.env]

  tf_spot_allocation_strategy = {
    uat  = var.spot_allocation_strategy
    prod = var.spot_allocation_strategy
    dev  = var.spot_allocation_strategy
  }
  spot_allocation_strategy = local.tf_spot_allocation_strategy[local.env]
  tf_on_demand_percentage_above_base_capacity = {
    dev  = "0"
    prod = "60"
    uat  = "60"
  }
  on_demand_percentage_above_base_capacity = local.tf_on_demand_percentage_above_base_capacity[local.env]

  tf_spot_instance_pools = {
    uat  = "2"
    prod = "2"
    dev  = "2"
  }
  spot_instance_pools = local.tf_spot_instance_pools[local.env]
}
