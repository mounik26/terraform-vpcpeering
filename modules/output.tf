output "PublicIP" {
  value = aws_instance.public_instance.public_ip

}
output "PublicIP1" {
    value = aws_instance.public_instance1.public_ip

}
output "main" {
  value = aws_vpc.main.id
}
output "testvpc" {
  value = aws_vpc.test-vpc.id
}
output "publicsubnet" {
  value = aws_subnet.public.id
}
output "public1subnet" {
  value = aws_subnet.public1.id
}
output "igw" {
  value = aws_internet_gateway.igw.id
}
output "igw1" {
  value = aws_internet_gateway.igw1.id
}
output "PublicRT" {
  value = aws_route_table.PublicRT.id
}
output "PublicRT1" {
  value = aws_route_table.PublicRT1.id
}
output "allowssh" {
  value = aws_security_group.allow_ssh.id
}
output "allowssh1" {
  value = aws_security_group.allow_ssh1.id
}
output "publicinstance" {
  value = aws_instance.public_instance.id
}
output "publicinstance1" {
  value = aws_instance.public_instance1.id
}
output "keyname1" {
  value = aws_key_pair.deployer.key_name
}
output "keyname" {
  value = aws_key_pair.deployer1.key_name
}
output "peeringid" {
  value = aws_vpc_peering_connection.vpcpeeringdemo.id
}