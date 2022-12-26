output "sec_grop_id" {
  value = aws_security_group.lyrebird["priv"].id
}

output "pub_sec_gr" {
  value = aws_security_group.lyrebird["public"].id
}


output "pub_sub_id" {
  value = aws_subnet.lyrebird_pub_sub.*.id
}

output "vpc_id" {
  value = aws_vpc.lyrebird_vpc.id
}

output "priv_sub_id" {
  value = aws_subnet.lyrebird_priv_sub.*.id
}