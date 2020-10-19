resource "aws_route_table" "pub_route" {
  vpc_id = var.cluster_vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }
}

resource "aws_route_table_association" "pub_sub_1" {
  subnet_id      = var.pub_sub_1_id
  route_table_id = aws_route_table.pub_route.id
}

resource "aws_route_table_association" "pub_sub_2" {
  subnet_id      = var.pub_sub_2_id
  route_table_id = aws_route_table.pub_route.id
}

resource "aws_route_table" "priv_route" {
  vpc_id = var.cluster_vpc_id

}

resource "aws_route_table_association" "priv_sub_1" {
  subnet_id      = var.priv_sub_1_id
  route_table_id = aws_route_table.priv_route.id
}

resource "aws_route_table_association" "priv_sub_2" {
  subnet_id      = var.priv_sub_2_id
  route_table_id = aws_route_table.pub_route.id
}