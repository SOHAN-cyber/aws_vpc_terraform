module "ec2-instance" {
  source                      = "../modules/ec2-instance"
  instance_count              = 1
  region                      = "ap-south-1"
  ami                         = "ami-062df10d14676e201"
  instance_type               = "t3.large"
  subnet_id                   = "subnet-08088efb89941f237"
  disable_api_stop            = false
  associate_public_ip_address = false
  keypair_name                = "jenkins"
  sg_id                       = "sg-062801bbcd51b2910"
  disable_api_termination     = false
  volume_size                 = "30"
  volume_type                 = "gp3"
  delete_on_termination       = true
  volume_tags                 = "my_volume"
  tags                        = "my_instance"
}
