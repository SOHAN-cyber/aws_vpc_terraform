variable "cidr_block" {
  description = "Provide the cidr range for your vpc"
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_dns_support" {
  description = "Do you want to enable your dns support in vpc"
  default     = true
}

variable "create_public_subnet" {
  description = "Do you want to create public subnet"
  type        = bool
  default     = true
}

variable "public_cidr_block" {
  description = "Provide the cidr block for subnet that you want to create"
  type        = list(string)
  default     = ["10.0.0.0/21", "10.0.8.0/21"]
}

variable "availability_zone" {
  description = "In which availability zone you want to create your subnet"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "map_public_ip_on_launch" {
  description = "Do you want to attach public ip on launching the instance"
  type        = bool
  default     = true
}

variable "create_private_subnet" {
  description = "Do you want to create public subnet"
  type        = bool
  default     = true
}

variable "private_cidr_block" {
  description = "Provide the cidr range for private subnet"
  type        = list(string)
  default     = ["10.0.16.0/21", "10.0.24.0/21", "10.0.32.0/21", "10.0.40.0/21", "10.0.48.0/21", "10.0.56.0/21"]
}