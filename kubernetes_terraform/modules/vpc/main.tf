resource "aws_vpc" "cluster_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "kubernetes_cluster_vpc"
  }
}

locals {
  cluster_name = "eks_test_cluster"
}

resource "aws_subnet" "pub_sub_1" {
  vpc_id = aws_vpc.cluster_vpc.id 
  cidr_block = var.pub_sub_1_cidr
  map_public_ip_on_launch = "true"
  availability_zone = var.az_alpha

  tags = {
    Name = "pub_sub_1"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "pub_sub_2" {
  vpc_id = aws_vpc.cluster_vpc.id 
  cidr_block = var.pub_sub_2_cidr
  map_public_ip_on_launch = "true"
  availability_zone = var.az_bravo

  tags = {
    Name = "pub_sub_2"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "priv_sub_1" {
  vpc_id = aws_vpc.cluster_vpc.id 
  cidr_block = var.priv_sub_1_cidr
  availability_zone = var.az_alpha

  tags = {
    Name = "priv_sub_1"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "priv_sub_2" {
  vpc_id = aws_vpc.cluster_vpc.id 
  cidr_block = var.priv_sub_2_cidr
  availability_zone = var.az_bravo

  tags = {
    Name = "priv_sub_2"
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
}

resource "aws_internet_gateway" "cluster_igw" {
  vpc_id = aws_vpc.cluster_vpc.id

  tags = {
    Name = "Cluster_IGW"
  }
}