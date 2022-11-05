output "alb_dns" {
    value = aws_lb.my-lb.dns_name
}