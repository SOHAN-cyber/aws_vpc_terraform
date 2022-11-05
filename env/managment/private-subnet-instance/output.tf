output "private_ec2_instance" {
  value = aws_instance.private-server.*.id
}

output "target_group_arn" {
  value = aws_lb_target_group.private-subnet-instance.arn
}

output "target_group_id" {
  value = aws_lb_target_group.private-subnet-instance.id
}