terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.14"
    }

    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.5.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.24.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }

    wiz = {
      version = " ~> 1.1"
      source  = "tf.app.wiz.io/wizsec/wiz"
    }

  }
}

provider "wiz" {
  client_id = var.wiz_auth_client_id
  secret    = var.wiz_auth_client_secret

}

provider "kubectl" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.default.token
  load_config_file       = false
}


provider "aws" {
  region     = var.REGION
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY

  default_tags {
    tags = {
      Environment = "dev"
      Team        = "Ravikumar"
      Repository  = "https://github.com/aws-development/terraform-aws-eks-deployment"
      Service     = "eks"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.default.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority.0.data)
    token                  = "k8s-aws-v1.aHR0cHM6Ly9zdHMuYXAtc291dGhlYXN0LTEuYW1hem9uYXdzLmNvbS8_QWN0aW9uPUdldENhbGxlcklkZW50aXR5JlZlcnNpb249MjAxMS0wNi0xNSZYLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFTSUFURFRZNzVVRUtBRlZYSTdGJTJGMjAyNDAxMDIlMkZhcC1zb3V0aGVhc3QtMSUyRnN0cyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjQwMTAyVDA4MjY0N1omWC1BbXotRXhwaXJlcz02MCZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QlM0J4LWs4cy1hd3MtaWQmWC1BbXotU2VjdXJpdHktVG9rZW49SVFvSmIzSnBaMmx1WDJWakVLaiUyRiUyRiUyRiUyRiUyRiUyRiUyRiUyRiUyRiUyRndFYURtRndMWE52ZFhSb1pXRnpkQzB4SWtnd1JnSWhBTVNIcTAlMkZuMVZkVmZ6YWd1WUlNd3FKWGFmSDlvQjJBaG5vQ3B3ViUyQkhoRUVBaUVBdW9nYUZkNCUyRllGOHlnczdXVm81ZjFTM1MwQ2JkY2ZLYW85SW9TbzBuSEkwcXpBVUlRUkFBR2d3eU1UTTVNamd6TnpNMU1USWlEQ29UR1NtJTJGNFhzNUZkdDF2eXFwQmRoQTIlMkJ6bGZCbFpCNWlLUXl5a2NRaiUyQkNPU3g0b29JbXk1bk9NWlVJNVp1c1Q2OVowS1JhajlIdyUyRjY2MVVsb1E3UVFOTnJMa2QyVWhienc5SGdxWWM5ZXh2TFltYXklMkZpaDA5TUt2R3h1WjExNzgzdXNqdXNpdkgyWWV4aXdBSW0xN0Iyc3ZvNGtwdEFLeHJIOFN5Y2ZTVm5NMjJWajVUSWxQVWpQJTJCaXk0c2F1SE14SlJicjZHeEVmanlacUJUWlFJd2xLQ21WakJYTnVoRGpNdHU5VU5POUdwQTlseE9VWkdFMUQyelB1ekdCWEI2V1dzcGJxNXI5S1NOR3ZWZXYwQXoxQWo4TTJ5ZFJ6STR6RkowSng3VmFmRUFxc29PcUhBVEhCMjJpZ0s1Zmp0ZDRCa2dBUGRmJTJCamc1TVE1Q1FMN05ObUgyaThGMU45Ukk5RzNnJTJCTTZtckh1cnBteWk3UE12Q2ZWWG96RXBBdHVjeWV4emolMkZsVVFBZmhnWjhud1JkYUhoVG54JTJGN3VvV01kOUJYN0x1NyUyRm9xaGhKUEZURWhDTWNac29vM1NXRCUyRkx0WHJvYWlwZnRFTVZqemwza0NJY2tsYWolMkJXWGQyRFRPSlZicGJyU2Q2NmVrb3YwZVozZ0c0UUE2TnNFVjFLRzNiYURoMHFoeUFuTU9yTzNIcEJQeG5YUlRKdmRWcVZLSFV0NVJZYXVYMXVWR3ZEaiUyRk96dUFKdE41c2pQSnhrNUhKTVNBVlR3MHVUR2NxWVVqZnVGJTJCQ2J5TGRLM3dvTjJTRVJQUlg2cmlCRUtpOTd4UHNRTjlaQ1FQRlFhTVp2RiUyQmlMY3dJcjRrN2tHVzZubUlQNlY5N3ZiMTdDZUlINm9UU1RTWHNDb2RsU093a2VEREtVYUV1bG1BSUZlM01jRThxbG5mQTFYcU1tSFFJRFlXOGNYQm5sdWl3dURBNUI2QUltWThheUZ5SHNJWFYyOXhxeXhvWEFQNEcxbzZKRGdQWFQlMkJPUVhFand0YzdUdjZtTGkzTWFPTlhWWVg4JTJGZjFYRElCNG5UOEZQMlBDeFdabUtNNzJyWmhhYTJZdWxvZWJxWHhsV1pzN2EyM2NRVThOJTJGJTJGeWtRWXVFcGZiVEluOSUyQjZYS0dONXJsdkRrYVpzNjdJbThoJTJGRDBVQkpBTTVKOGM5Rmw4TFREUkhONnBPMVc1N0xVQ2dvNHk1OXZ1NFczVENNZ00lMkJzQmpxd0FWckNNbUN4eFliTlc5b0NaVDB5RXdTM1VuTDhaTUUxY1E0YmR4MkpSWkdXWldPb1FObE9YbnRTM2E5STRuNW1HJTJGS29rSGV2aGFTWm50NUNXbFMlMkJQSVpWZTMzRGI1SDhFU3c3TjNtMkpQUmtLTVFIdnIlMkZWdkwxQWUlMkJyWHNDcHo5dzdYbnFDRTJKajFrenVJNGpOOEdHRlglMkJiJTJCUHlaU3BNV3pZNUFGT29BWjdiTFBNRGhjS2lkTnRqYzh5RURaQUFUWGYyNE42bUdwOWZVdWNNanNDWXdLdkdwRVFKSU9lNzFvRHgxV0ZMdGpPJlgtQW16LVNpZ25hdHVyZT1lNTdhMGE2ZGIzY2JhNzIyMGQ4YTdiNzFjYzFlZTdlNzYxZjUwOGYxZDRhM2JjOTdiNGJlOWNjZjJiOTM2OWQz"

    #token                  = data.aws_eks_cluster_auth.default.token
    #exec {
    #  api_version = "client.authentication.k8s.io/v1beta1"
    #  command     = "aws"
    #  args        = ["eks", "get-token", "--cluster-name", "${var.name_prefix}-cluster"]
    #}
  }
}

provider "kubernetes" {
  #apply_retry_count      = 5
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority.0.data) #  load_config_file       = false
  #token                  = data.aws_eks_cluster_auth.default.token
  token = "k8s-aws-v1.aHR0cHM6Ly9zdHMuYXAtc291dGhlYXN0LTEuYW1hem9uYXdzLmNvbS8_QWN0aW9uPUdldENhbGxlcklkZW50aXR5JlZlcnNpb249MjAxMS0wNi0xNSZYLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFTSUFURFRZNzVVRUtBRlZYSTdGJTJGMjAyNDAxMDIlMkZhcC1zb3V0aGVhc3QtMSUyRnN0cyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjQwMTAyVDA4MjY0N1omWC1BbXotRXhwaXJlcz02MCZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QlM0J4LWs4cy1hd3MtaWQmWC1BbXotU2VjdXJpdHktVG9rZW49SVFvSmIzSnBaMmx1WDJWakVLaiUyRiUyRiUyRiUyRiUyRiUyRiUyRiUyRiUyRiUyRndFYURtRndMWE52ZFhSb1pXRnpkQzB4SWtnd1JnSWhBTVNIcTAlMkZuMVZkVmZ6YWd1WUlNd3FKWGFmSDlvQjJBaG5vQ3B3ViUyQkhoRUVBaUVBdW9nYUZkNCUyRllGOHlnczdXVm81ZjFTM1MwQ2JkY2ZLYW85SW9TbzBuSEkwcXpBVUlRUkFBR2d3eU1UTTVNamd6TnpNMU1USWlEQ29UR1NtJTJGNFhzNUZkdDF2eXFwQmRoQTIlMkJ6bGZCbFpCNWlLUXl5a2NRaiUyQkNPU3g0b29JbXk1bk9NWlVJNVp1c1Q2OVowS1JhajlIdyUyRjY2MVVsb1E3UVFOTnJMa2QyVWhienc5SGdxWWM5ZXh2TFltYXklMkZpaDA5TUt2R3h1WjExNzgzdXNqdXNpdkgyWWV4aXdBSW0xN0Iyc3ZvNGtwdEFLeHJIOFN5Y2ZTVm5NMjJWajVUSWxQVWpQJTJCaXk0c2F1SE14SlJicjZHeEVmanlacUJUWlFJd2xLQ21WakJYTnVoRGpNdHU5VU5POUdwQTlseE9VWkdFMUQyelB1ekdCWEI2V1dzcGJxNXI5S1NOR3ZWZXYwQXoxQWo4TTJ5ZFJ6STR6RkowSng3VmFmRUFxc29PcUhBVEhCMjJpZ0s1Zmp0ZDRCa2dBUGRmJTJCamc1TVE1Q1FMN05ObUgyaThGMU45Ukk5RzNnJTJCTTZtckh1cnBteWk3UE12Q2ZWWG96RXBBdHVjeWV4emolMkZsVVFBZmhnWjhud1JkYUhoVG54JTJGN3VvV01kOUJYN0x1NyUyRm9xaGhKUEZURWhDTWNac29vM1NXRCUyRkx0WHJvYWlwZnRFTVZqemwza0NJY2tsYWolMkJXWGQyRFRPSlZicGJyU2Q2NmVrb3YwZVozZ0c0UUE2TnNFVjFLRzNiYURoMHFoeUFuTU9yTzNIcEJQeG5YUlRKdmRWcVZLSFV0NVJZYXVYMXVWR3ZEaiUyRk96dUFKdE41c2pQSnhrNUhKTVNBVlR3MHVUR2NxWVVqZnVGJTJCQ2J5TGRLM3dvTjJTRVJQUlg2cmlCRUtpOTd4UHNRTjlaQ1FQRlFhTVp2RiUyQmlMY3dJcjRrN2tHVzZubUlQNlY5N3ZiMTdDZUlINm9UU1RTWHNDb2RsU093a2VEREtVYUV1bG1BSUZlM01jRThxbG5mQTFYcU1tSFFJRFlXOGNYQm5sdWl3dURBNUI2QUltWThheUZ5SHNJWFYyOXhxeXhvWEFQNEcxbzZKRGdQWFQlMkJPUVhFand0YzdUdjZtTGkzTWFPTlhWWVg4JTJGZjFYRElCNG5UOEZQMlBDeFdabUtNNzJyWmhhYTJZdWxvZWJxWHhsV1pzN2EyM2NRVThOJTJGJTJGeWtRWXVFcGZiVEluOSUyQjZYS0dONXJsdkRrYVpzNjdJbThoJTJGRDBVQkpBTTVKOGM5Rmw4TFREUkhONnBPMVc1N0xVQ2dvNHk1OXZ1NFczVENNZ00lMkJzQmpxd0FWckNNbUN4eFliTlc5b0NaVDB5RXdTM1VuTDhaTUUxY1E0YmR4MkpSWkdXWldPb1FObE9YbnRTM2E5STRuNW1HJTJGS29rSGV2aGFTWm50NUNXbFMlMkJQSVpWZTMzRGI1SDhFU3c3TjNtMkpQUmtLTVFIdnIlMkZWdkwxQWUlMkJyWHNDcHo5dzdYbnFDRTJKajFrenVJNGpOOEdHRlglMkJiJTJCUHlaU3BNV3pZNUFGT29BWjdiTFBNRGhjS2lkTnRqYzh5RURaQUFUWGYyNE42bUdwOWZVdWNNanNDWXdLdkdwRVFKSU9lNzFvRHgxV0ZMdGpPJlgtQW16LVNpZ25hdHVyZT1lNTdhMGE2ZGIzY2JhNzIyMGQ4YTdiNzFjYzFlZTdlNzYxZjUwOGYxZDRhM2JjOTdiNGJlOWNjZjJiOTM2OWQz"
  #exec {
  #  api_version = "client.authentication.k8s.io/v1beta1"
  #  command     = "aws"
  #  args        = ["eks", "get-token", "--cluster-name", "${var.name_prefix}-cluster"]
  #}
}

/*
provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks.token
}
*/

data "aws_eks_cluster" "default" {
  depends_on = [aws_eks_cluster.cluster]
  name       = "${var.name_prefix}-cluster"
}

data "aws_eks_cluster_auth" "default" {
  depends_on = [aws_eks_cluster.cluster]
  name       = "${var.name_prefix}-cluster"
}
