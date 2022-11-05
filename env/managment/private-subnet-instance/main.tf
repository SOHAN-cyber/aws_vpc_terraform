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
  provisioner "file" {
source = "./script.sh"   #this is the source for copying the file 
destination = "/home/ubuntu/script.sh"   #this is for destion of file to be copied
}

connection {
type = "ssh"
user = "ec2-user"
host = aws_instance.private-server[count.index].public_ip  #this is for login into the instance app-server
private_key = file("../private-subnet")   #this is the location for the key of the instance
timeout = "4m"  #after 4 minute if instance is not able to lofin then it will show timeout error
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
    ingress {
    description = "SSH from my ip"
    from_port   = 80
    to_port     = 80
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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDfMniuHl2Vb58jAN7WU0fXo2VADj1BGyj6W/NVNx10lPJ662uLRvHNuxaxZ7JXa68Zy3UCSIMPsNusoT4yw/4H+h970mULtkF8zpINY8QiHVuCEsSQbUt2dpyexIwWtz+freTwst+5id4tlMIzuM/e9SVjnOa7EuVqhfL23buEzGPux+SF1W/96q1bGBN3BQ2/wUb8ZRm3p34mcVT125V2MYZe497n9r8BGxE32ExbfzhhT2pPZSsyejHneQdeLKI7eV1L3rHLlyLD1NzI5+MuHwqfimAcqNivRxwHJSD49JymZbBUunlg+6MzbFwYs2CwZT1eLtIFimnIN/WICJbID1WtYQpK08nLfh5FT8995Bm36vZ6scGvg7MPnZa+HxCtpQj3bbUCm+7giOEIvh6hf813f6W1uNO/mb4eOJzIwd93wqs9tlXwZFIiD+DfAyvziN2strb++r/elwASINSyi2rd0op2b2mQhQtzQRss/Q3CDmWvABluRCjAtjRVle0= opstree@opstree-Latitude-3420"
}


resource "aws_lb_target_group" "private-subnet-instance" {
  name        = "private-subent"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  health_check {
    protocol            = "HTTP"
    healthy_threshold   = 5
    path                = "/"
    interval            = 30
    timeout             = 5
    unhealthy_threshold = 2
    enabled             = true
  }
}