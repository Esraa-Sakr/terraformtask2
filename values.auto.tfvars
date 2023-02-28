ami_id = "ami-0557a15b87f6559cf"

/*key_pair_name = "var.key_pair_name"*/

name_prefix = "my-app"

subnet_cidr_block = ["10.0.1.0/24", "10.0.2.0/24"]

subnet_count = 2


ami-0557a15b87f6559cf = "your-ami-value"
t2                    = "micro"
web_server_port       = 80

instance_type = "t2.micro"


/*variable "t2" {
  type = string
  default = "micro"
}*/



my-keypair = "mykey"
