output "vpc" {
  value = aws_vpc.rke2_vpc.id
}

output "pub_subnet" {
  value = aws_subnet.rke2_public.id
}

output "priv_subnet" {
  value = {
    for k, v in aws_subnet.rke2_private : k => v.id
}
}