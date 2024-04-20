terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.42.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
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
  name = "ambient-mesh"
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


  scaling_config {
    desired_size = 2
    min_size = 2
    max_size = 2
  }
  update_config {
    max_unavailable = 1
  }
}

