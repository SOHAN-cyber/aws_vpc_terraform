resource "aws_instance" "private-server" {
  count                       = var.instance_count
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = data.terraform_remote_state.vpc.outputs.private_subnet[count.index]
  disable_api_stop            = false
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = aws_key_pair.private-server-key.key_name
  vpc_security_group_ids      = [aws_security_group.private-server.id]
  disable_api_termination     = false
  root_block_device {
    volume_size           = "30"
    volume_type           = "gp2"
    encrypted             = false
    delete_on_termination = false
    tags = {
      Name = "my-jump-server-ebs"
    }
  }
  tags = {
    "Name" = "jump-server"
  }
}

resource "aws_security_group" "private-server" {
  name   = "private-server-sg"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description = "SSH from my ip"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["13.126.164.201/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "private-sg"
  }
}

resource "aws_key_pair" "private-server-key" {
  key_name   = "private-server-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCdyTGbPrkbHYOWBQd9qOKGoh2DRM0crNURmnOy+sOPBKaj37gUScS1H21P+ICuFxVLyinzBLAWw3qP7W7NTGCd8FTP9ZQfRlFVv4CkrZ8adjnr742kyh453Z4BNG7XQjcgfh7TmEtX9qYblxUzhWF0F03G3rATyPOcOkOasdgfLq3jhEfyok4eCdoAaf656lo2smHvd8Th50OLZ7Hi+KkbI5EssqEuu2lz0qJiiy1S+C9zFEcg5X43ZLv0WcTytOq2G0bVFx8YxaA5TKZ+32brOhFhLJ1qwzcX9OaLSZ3PeizFhZq3kx0hN8/RiHLbO+QmYJCcSjHndOHoFGub5biyvAY+PzbitsFjGmo7zJEyK09RMsmO+rgtot/GJ4e4qx6L2VkKAHQ7DYDw0ZTA0JXJnYXna7e5QJsxXuHofNkZPnPIQJ0tinRodIIWIPCxH3JmvNuPmebPwhe6I3DyQ/IrOTnYd2LYt7jNIdciviGWXkbjKdpbE1/5/w4nvSQFDE= opstree@opstree-Latitude-3420"
}
