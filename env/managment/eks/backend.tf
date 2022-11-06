data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "dev-tf-states"
    key    = "env/management/network"
    region = "ap-south-1"
  }
}

data "terraform_remote_state" "public-subnet-instance" {
  backend = "s3"
  config = {
    bucket = "dev-tf-states"
    key    = "env/management/ec2.tfstate"
    region = "ap-south-1"
  }
}

data "terraform_remote_state" "private-subnet-instance" {
  backend = "s3"
  config = {
    bucket = "dev-tf-states"
    key    = "env/management/private.tfstate"
    region = "ap-south-1"
  }
}


data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
    bucket = "dev-tf-states"
    key    = "env/management/alb.tfstate"
    region = "ap-south-1"
  }
}

terraform {
  backend "s3" {
    bucket = "dev-tf-states"
    key    = "env/management/eks.tfstate"
    region = "ap-south-1"
  }
}


