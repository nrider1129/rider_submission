### Provide Credentials for Authentication with AWS ###
provider "aws" {
    region                      = "us-east-1"
    shared_credentials_file     = "~/.aws/credentials"
    profile                     = "default"
}

### Basic VPC Creation with 4 subnets ###

module "vpc" {
    source                      = "./modules/vpc"
    vpc_cidr                    = var.cluster_vpc_cidr
    pub_sub_1_cidr              = var.pub1_cidr
    pub_sub_2_cidr              = var.pub2_cidr
    priv_sub_1_cidr             = var.priv1_cidr
    priv_sub_2_cidr             = var.priv2_cidr
    az_alpha                    = var.availability_zone_alpha
    az_bravo                    = var.availability_zone_bravo
}

### Routes and subnet associations. Routes are only back to my computer ###

module "routes" {
    source                      = "./modules/routes"
    cluster_vpc_id              = "${module.vpc.cluster_vpc_id}"
    igw_id                      = "${module.vpc.igw_id}"
    pub_sub_1_id                = "${module.vpc.pub_sub_1_id}"
    pub_sub_2_id                = "${module.vpc.pub_sub_2_id}"
    priv_sub_1_id               = "${module.vpc.priv_sub_1_id}"
    priv_sub_2_id               = "${module.vpc.priv_sub_2_id}"
}

### EKS Cluster Creation (Endpoint and CA will output during apply or be found in data)

module "eks_cluster" {
    source                      = "./modules/eks_cluster"
    pub_sub_1_id                = "${module.vpc.pub_sub_1_id}"
    pub_sub_2_id                = "${module.vpc.pub_sub_2_id}"
    priv_sub_1_id               = "${module.vpc.priv_sub_1_id}"
    priv_sub_2_id               = "${module.vpc.priv_sub_2_id}"
}

### EKS Node group created for cluster ###

module "eks_node_group" {
    source                      = "./modules/eks_node_group"
    eks_cluster_name            = "${module.eks_cluster.eks_cluster_name}"
    cluster_vpc_id              = "${module.vpc.cluster_vpc_id}"
    vpc_cidr_block              = "${module.vpc.cluster_vpc_cidr}"
    pub_sub_1_id                = "${module.vpc.pub_sub_1_id}"
    pub_sub_2_id                = "${module.vpc.pub_sub_2_id}"
    priv_sub_1_id               = "${module.vpc.priv_sub_1_id}"
    priv_sub_2_id               = "${module.vpc.priv_sub_2_id}"
}