variable "ami" {
  description = "Provide the Image ID for your instance"
  type        = string
  default     = "ami-062df10d14676e201"
}

variable "instance_type" {
  description = "instance type that you want to create"
  type        = string
  default     = "t3.large"
}

variable "instance_count" {
  description = "How many instance do you want"
  type        = number
  default     = 1
}

variable "associate_public_ip_address" {
  description = "Do you want to attach public ip on launching the instance"
  type        = bool
  default     = false
}
