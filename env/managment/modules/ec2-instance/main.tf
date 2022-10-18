resource "aws_instance" "server" {
  count                       = var.instance_count
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  disable_api_stop            = var.disable_api_stop
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = var.keypair_name
  vpc_security_group_ids      = ["${var.sg_id}"]
  disable_api_termination     = var.disable_api_termination
  root_block_device {
    volume_size           = var.volume_size
    volume_type           = var.volume_type
    encrypted             = var.encryption
    delete_on_termination = var.delete_on_termination
    tags = {
      Name = var.volume_tags
    }
  }
  tags = {
    "Name" = var.tags
  }
}