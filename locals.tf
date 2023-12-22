locals {


  tf_eks_worker_node_keypair = {
    uat  = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAj6aF5unZBN1Emq8D4Jhddi5/YmBBkxx0md6pO5xZPZ7aPSDPng4d1n6dkGU1mE1ZSzT/ttGfZOPd0AWYGxEa5Hce1FHPv3zcJy8JFC/mxjeXRVRTX01mphvk5GT/3JqP5qSzPynkS6p15GIIq26Mr8AXOmmSwCYqVY+c52L1sogQtxL+KC9/kKqjYYTdWUOMZ6bIKtnobYtix3P+E/dkuQInytgjrie8tSs1CNZ1cKikma231MdWJhlQCrgLdINd15cOskSJoy/ti3FEK0PONmjEyJm84Yl77v7f8hJPjASQ9ZmtRFQ0LedFBgmwmCGhInAHtErVIU1Ng2+GpVs0mw=="
    prod = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAj6aF5unZBN1Emq8D4Jhddi5/YmBBkxx0md6pO5xZPZ7aPSDPng4d1n6dkGU1mE1ZSzT/ttGfZOPd0AWYGxEa5Hce1FHPv3zcJy8JFC/mxjeXRVRTX01mphvk5GT/3JqP5qSzPynkS6p15GIIq26Mr8AXOmmSwCYqVY+c52L1sogQtxL+KC9/kKqjYYTdWUOMZ6bIKtnobYtix3P+E/dkuQInytgjrie8tSs1CNZ1cKikma231MdWJhlQCrgLdINd15cOskSJoy/ti3FEK0PONmjEyJm84Yl77v7f8hJPjASQ9ZmtRFQ0LedFBgmwmCGhInAHtErVIU1Ng2+GpVs0mw=="
    dev  = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAj6aF5unZBN1Emq8D4Jhddi5/YmBBkxx0md6pO5xZPZ7aPSDPng4d1n6dkGU1mE1ZSzT/ttGfZOPd0AWYGxEa5Hce1FHPv3zcJy8JFC/mxjeXRVRTX01mphvk5GT/3JqP5qSzPynkS6p15GIIq26Mr8AXOmmSwCYqVY+c52L1sogQtxL+KC9/kKqjYYTdWUOMZ6bIKtnobYtix3P+E/dkuQInytgjrie8tSs1CNZ1cKikma231MdWJhlQCrgLdINd15cOskSJoy/ti3FEK0PONmjEyJm84Yl77v7f8hJPjASQ9ZmtRFQ0LedFBgmwmCGhInAHtErVIU1Ng2+GpVs0mw=="
  }
  eks_worker_node_keypair = local.tf_eks_worker_node_keypair[var.env]


  ####user data for kubectl binary installation

  tf_eks_kubectl_node_userdata = {
    uat  = <<USERDATA
#!/bin/bash
set -o xtrace
# Install HTTP server
echo "installing HTTP server"
yum install -y httpd
systemctl start httpd
systemctl enable httpd
# Create sample index page
echo "<h1>Hello World from EC2 kubectl instance!</h1>" > /var/www/html/index.html
echo "HTTP server installed"
echo "installing ssm agent"
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl start amazon-ssm-agent
systemctl enable amazon-ssm-agent
echo "ssm agent installed"
echo "installing collectd agent"
amazon-linux-extras install collectd
echo "collectd agent installed"

#install kubectl binary
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.3/2023-11-14/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
#install helm
sudo yum install openssl
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
helm version | cut -d + -f 1
#install eksctl
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
sudo mv /tmp/eksctl /usr/local/bin
aws eks update-kubeconfig --region '${var.REGION}' --name '${aws_eks_cluster.cluster.name}
USERDATA
    prod = <<USERDATA
#!/bin/bash
set -o xtrace
# Install HTTP server
echo "installing HTTP server"
yum install -y httpd
systemctl start httpd
systemctl enable httpd
# Create sample index page
echo "<h1>Hello World from EC2 kubectl instance!</h1>" > /var/www/html/index.html
echo "HTTP server installed"
echo "installing ssm agent"
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl start amazon-ssm-agent
systemctl enable amazon-ssm-agent
echo "ssm agent installed"
echo "installing collectd agent"
amazon-linux-extras install collectd
echo "collectd agent installed"

#install kubectl binary
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.3/2023-11-14/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
#install helm
sudo yum install openssl
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
helm version | cut -d + -f 1
#install eksctl
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
sudo mv /tmp/eksctl /usr/local/bin
aws eks update-kubeconfig --region '${var.REGION}' --name '${aws_eks_cluster.cluster.name}
USERDATA
    dev  = <<USERDATA
#!/bin/bash
set -o xtrace
# Install HTTP server
echo "installing HTTP server"
yum install -y httpd
systemctl start httpd
systemctl enable httpd
# Create sample index page
echo "<h1>Hello World from EC2 kubectl instance!</h1>" > /var/www/html/index.html
echo "HTTP server installed"
echo "installing ssm agent"
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl start amazon-ssm-agent
systemctl enable amazon-ssm-agent
echo "ssm agent installed"
echo "installing collectd agent"
amazon-linux-extras install collectd
echo "collectd agent installed"

#install kubectl binary

curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.3/2023-11-14/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH

#install helm
sudo yum install openssl
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
helm version | cut -d + -f 1
#install eksctl
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
sudo mv /tmp/eksctl /usr/local/bin 
aws eks update-kubeconfig --region '${var.REGION}' --name '${aws_eks_cluster.cluster.name}
USERDATA
  }
  eks_kubectl_node_userdata = local.tf_eks_kubectl_node_userdata[var.env]

  eks_dns_cluster_ip = cidrhost(var.eks_service_ipv4_cidr, 10) # set to X.X.X.10 for CoreDNS service

  events = {
    health_event = {
      name        = "HealthEvent"
      description = "Karpenter interrupt - AWS health event"
      event_pattern = {
        source      = ["aws.health"]
        detail-type = ["AWS Health Event"]
      }
    }
    spot_interupt = {
      name        = "SpotInterrupt"
      description = "Karpenter interrupt - EC2 spot instance interruption warning"
      event_pattern = {
        source      = ["aws.ec2"]
        detail-type = ["EC2 Spot Instance Interruption Warning"]
      }
    }
    instance_rebalance = {
      name        = "InstanceRebalance"
      description = "Karpenter interrupt - EC2 instance rebalance recommendation"
      event_pattern = {
        source      = ["aws.ec2"]
        detail-type = ["EC2 Instance Rebalance Recommendation"]
      }
    }
    instance_state_change = {
      name        = "InstanceStateChange"
      description = "Karpenter interrupt - EC2 instance state-change notification"
      event_pattern = {
        source      = ["aws.ec2"]
        detail-type = ["EC2 Instance State-change Notification"]
      }
    }
  }
}
