terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.42.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.13.2"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.30.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.this.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.this.name]
      command     = "aws"
    }
  }
}

provider "kubernetes" {
    host                   = aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.this.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.this.name]
      command     = "aws"
    }
}

data "aws_iam_role" "lab-role" {
  name = "LabRole"
}

data "aws_vpc" "this" {
  default = true
}
data "aws_subnets" "this" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
  filter {
    name = "availability-zone"
    values = ["us-east-1a", "us-east-1b"]
  }
}


resource "aws_eks_cluster" "this" {
  name = "${var.mode}-mesh"
  role_arn = data.aws_iam_role.lab-role.arn

  vpc_config {
    subnet_ids = data.aws_subnets.this.ids
  }
}
resource "aws_eks_node_group" "this" {
  cluster_name = aws_eks_cluster.this.name
  node_group_name = "node-group"
  node_role_arn = data.aws_iam_role.lab-role.arn
  subnet_ids = data.aws_subnets.this.ids

  instance_types = [ "t3.xlarge" ]

  scaling_config {
    desired_size = 2
    min_size = 2
    max_size = 2
  }
  update_config {
    max_unavailable = 1
  }
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "coredns"
}

module "ambient" {
  source = "./modules/ambient"

  count = var.mode == "ambient" ? 1 : 0

  depends_on = [ aws_eks_addon.coredns, aws_eks_addon.vpc_cni, aws_eks_cluster.this, aws_eks_node_group.this ]
}

module "regular" {
  source = "./modules/regular"

  count = var.mode == "regular" ? 1 : 0

  depends_on = [ aws_eks_addon.coredns, aws_eks_addon.vpc_cni, aws_eks_cluster.this, aws_eks_node_group.this ]
}

variable "mode" {
  type = string

  validation {
    condition = contains(["regular", "ambient"], var.mode)
    error_message = "mode must be one of regular, ambient"
  }
}