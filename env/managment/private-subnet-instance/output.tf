output "private_ec2_instance" {
  value = aws_instance.private-server.*.id
}