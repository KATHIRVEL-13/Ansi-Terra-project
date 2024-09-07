#  variables.tf
variable "instance_name" {
  description = "Name of the instance to be created"
  default     = "Test-instance"
}

variable "instance_type" {
  description = "Type of instance to be created"
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "The VPC subnet the instance(s) will be created in"
  default     = "subnet-0786206ce1cbc3f7c"
}

variable "ami_id" {
  description = "The AMI to use"
  default     = "ami-0e86e20dae9224db8"
}

variable "number_of_instances" {
  description = "Number of instances to be created"
  default     = 1
}

variable "ami_key_pair_name" {
  description = "Key pair name for the instances"
  default     = "DevOps"
}

variable "resource_tags" {
  description = "Tags for the VM on cloud"
  default     = "Test-VM"
}

