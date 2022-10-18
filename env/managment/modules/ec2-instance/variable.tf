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
  default     = 6
}

variable "associate_public_ip_address" {
  description = "Do you want to attach public ip on launching the instance"
  type        = bool
  default     = false
}

variable "sg_id" {
  description = "Provide the security group id for instance"
}

variable "disable_api_termination" {
  description = "Do you want to enable the termination"
  type        = bool
  default       = false
}

variable "disable_api_stop" {
  description = "Do you want to enable the termination"
  type        = bool
  default       = false
}

variable "keypair_name" {
  description = "key_name name"
}

variable "region" {
  description = "region for instance creation"
}

variable "volume_size" {
  description = "How much size of volume you want to create"
  type        = string
  default     = "30"
}

variable "volume_type" {
  description = "Type of volume you want to create"
  type        = string
  default     = "gp2"
}

variable "encryption" {
  description = "Do you want to enable the encryption or not"
  type        = bool
  default     = false
}


variable "delete_on_termination" {
  description = "Do you want to delete the volume on termination"
  type        = bool
  default     = true
}

variable "volume_tags" {
  description = "tags your volume"
  type        = string
  default     = "my_module_volume"
}

variable "tags" {
  description = "provide the tag for your instances"
  type        = string
  default     = "my_module_instance"
}

variable "subnet_id" {
  description = "subnet id for your instance"
  type        = string
  default     = null
}
