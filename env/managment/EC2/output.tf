output "ec2_instance" {
  value = aws_instance.jump-server.id
}

output "jump_server_ip" {
  value = aws_instance.jump-server.public_ip
}

output "jump_sg_id" {
  value = aws_security_group.jump-server.id
}