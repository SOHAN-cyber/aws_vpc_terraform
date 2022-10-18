output "instance_ip" {
    value = aws_instance.server.*.id
}