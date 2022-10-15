terraform {
  backend "s3" {
    bucket = "dev-tf-states"
    key = "env/management/network"
    region = "ap-south-1"
  }
}