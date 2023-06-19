output "public_subnets" {
  value = aws_subnet.sn-projeto-publics[*]
}

output "private_subnets" {
  value = aws_subnet.sn-projeto-privates[*]
}

output "vpc_id" {
  value = aws_vpc.vpc-projeto.id
}

output "private_route_tables" {
  value = aws_route_table.rt-projeto-private
}

output "public_route_tables" {
  value = aws_route_table.rt-projeto-public
}