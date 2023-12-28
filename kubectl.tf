/*
resource "kubectl_manifest" "test" {
    yaml_body = <<YAML
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: test-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    azure/frontdoor: enabled
spec:
  rules:
  - http:
      paths:
      - path: /testpath
        pathType: "Prefix"
        backend:
          serviceName: test
          servicePort: 80
YAML
}

*/


resource "kubectl_manifest" "aws_auth" {
  yaml_body = <<YAML
apiVersion: v1
kind: ConfigMap
data:
  mapRoles: |
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: ${aws_iam_role.eks_node_group.arn}
      username: system:node:{{EC2PrivateDNSName}}
    - groups:
      - system:masters
      rolearn: ${aws_iam_role.kubectl_ssm_role.arn}
      username: system:node:{{EC2PrivateDNSName}}
metadata:
  labels:
    app.kubernetes.io/managed-by: Terraform
  name: aws-auth
  namespace: kube-system

YAML

  depends_on = [aws_eks_cluster.cluster]
}
/*
locals {
  aws_user_role = "arn:aws:iam::1234:role/AWSReservedSSO_AWSAdministratorAccess_ce861bcf52b0eabc"
  aws_terraform_role = "arn:aws:iam::1234:role/terraform-role-dev"

  aws_auth_configmap_yaml = <<-EOT
  ${chomp(module.eks.aws_auth_configmap_yaml)}
      - rolearn: ${local.aws_user_role}
        username: "LZadministratorsRole"
        groups:
          - system:masters
      - rolearn: ${local.aws_terraform_role}
        username: "LZTerraformRole"
        groups:
          - system:masters
  EOT
      # - rolearn: ${module.eks_managed_node_group.iam_role_arn}
      #   username: system:node:{{EC2PrivateDNSName}}
      #   groups:
      #     - system:bootstrappers
      #     - system:nodes
      # - rolearn: ${module.self_managed_node_group.iam_role_arn}
      #   username: system:node:{{EC2PrivateDNSName}}
      #   groups:
      #     - system:bootstrappers
      #     - system:nodes
      # - rolearn: ${module.fargate_profile.fargate_profile_arn}
      #   username: system:node:{{SessionName}}
      #   groups:
      #     - system:bootstrappers
      #     - system:nodes
      #     - system:node-proxier
}

*/
