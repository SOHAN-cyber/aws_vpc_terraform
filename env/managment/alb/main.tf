resource "aws_lb" "my-lb" {
  name = "my-lb-tf"
  internal = false 
  load_balancer_type = "application"
  security_group = [aws_security_group.alb.id]
  subnets = [data.terraform_remote_state.vpc.outputs.public_subnet[0][0], data.terraform_remote_state.vpc.outputs.public_subnet[0][1]]
  enable_deletion_protection = false
  enable_cross_zone_load_balancing =  true
  ip_address_type = "dualstack"
  tags {
    Name = "my-lb-tf"
  }
}

resource "aws_security_group" "alb" {
  name   = "alb-server-sg"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
      ingress {
    description = "HTTP port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "alb-sg"
  }
}


resource "aws_lb_listener" "front_end_80" {
  load_balancer_arn = aws_lb.my-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "HEALTHY"
      status_code  = "200"
    }

}
}

resource "aws_lb_listener_rule" "my-domain" {
  listener_arn = aws_lb_listener.front_end_80.arn
  action {
    type = "forward"
    target_group_arn = data.terraform_remote_state.private_ec2_instance.outputs.aws_lb_target_group.arn
  }

  condition {
    host_header {
      values = ["sohan.com"]
    }
  }
}