MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

--==MYBOUNDARY==
Content-Type: application/node.eks.aws

# AL2023 uses nodeadm. The legacy /etc/eks/bootstrap.sh no longer exists.
# https://awslabs.github.io/amazon-eks-ami/nodeadm/
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: ${CLUSTER_NAME}
    apiServerEndpoint: ${API_SERVER_URL}
    certificateAuthority: ${B64_CLUSTER_CA}
    cidr: ${SERVICE_IPV4_CIDR}

--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
set -ex
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# SSM agent is pre-installed on AL2023 EKS-optimized AMIs - just ensure it runs.
systemctl enable --now amazon-ssm-agent || true

--==MYBOUNDARY==--
