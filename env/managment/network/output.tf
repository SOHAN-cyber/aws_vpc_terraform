output "vpc_id" {
  value = aws_vpc.my-vpc.id
}

output "vpc_arn" {
  value = aws_vpc.my-vpc.arn
}

output "public_subnet" {
  value = aws_subnet.public_subnet.*.id
}

output "private_subnet" {
  value = aws_subnet.private_subnet.*.id
}