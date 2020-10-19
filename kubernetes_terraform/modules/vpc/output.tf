output "cluster_vpc_id" {
    value = "${aws_vpc.cluster_vpc.id}"
}

output "cluster_vpc_cidr" {
    value = "${aws_vpc.cluster_vpc.cidr_block}"
}

output "igw_id" {
    value = "${aws_internet_gateway.cluster_igw.id}"
}

output "pub_sub_1_id" {
    value = "${aws_subnet.pub_sub_1.id}"
}

output "pub_sub_2_id" {
    value = "${aws_subnet.pub_sub_2.id}"
}

output "priv_sub_1_id" {
    value = "${aws_subnet.priv_sub_1.id}"
}

output "priv_sub_2_id" {
    value = "${aws_subnet.priv_sub_2.id}"
}