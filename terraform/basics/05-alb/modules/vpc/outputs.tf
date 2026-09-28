output "vpc_id" {
  value = aws_vpc.mi_vpc.id
}

output "subnet_publica_id" {
  value = aws_subnet.subnet_publica.id
}

output "subnet_publica2_id" {
  value = aws_subnet.subnet_publica2.id
}
