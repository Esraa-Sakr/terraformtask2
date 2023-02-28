variable "vpc_name" {
  type    = string
  default = "my-vpc"
}

variable "subnet_count" {
  type        = number
  default     = 2
  description = "Number of subnets to create"
}

variable "subnet_cidr_block" {
  type        = list(string)
  description = "List of CIDR blocks for each subnet"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

/*variable "key_pair_name" {
  type        = string
  description = "Name of the key pair to use for SSH access"
}*/

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}


variable "name_prefix" {
  type    = string
  default = "my-prefix"
}

variable "ami-0557a15b87f6559cf" {
  description = "ID of the Amazon Machine Image (AMI) to use for the instance"
  default     = "ami-0557a15b87f6559cf"
}


variable "web_server_port" {}

variable "t2" {
  type    = string
  default = "micro"
}

variable "my-keypair" {
  type = string
}
