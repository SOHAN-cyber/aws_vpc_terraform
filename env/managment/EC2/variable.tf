variable "ami" {
  description = "Provide the Image ID for your instance"
  type        = string
  default     = "ami-062df10d14676e201"
}

variable "instance_type" {
  description = "instance type that you want to create"
  type = string
  default = "t2.micro"
}