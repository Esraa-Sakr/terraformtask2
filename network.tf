resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}


/*resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.region}a"
  tags = {
    Name = "${var.name_prefix}-subnet-${count.index}"
  }
  count = var.subnet_count
}*/

resource "aws_subnet" "my_subnet" {

  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "var.name_prefix}-subnet-${count.index + 1}"
  }
  count = var.subnet_count
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "internet_gateway"
  }
}



locals {
  private_ips = [
    aws_subnet.my_subnet.*.cidr_block[0],
  ]
}

resource "null_resource" "log_private_ips" {
  provisioner "local-exec" {
    command = "powershell.exe -Command \"Write-Output '${join("\n", local.private_ips)}' | Out-File -FilePath 'private_ips.log'\""
  }
}



/*resource "null_resource" "log_public_ip" {
  provisioner "local-exec" {
    command = "powershell.exe -Command \"Write-Output '${aws_instance.my_instance.public_ip}' | Out-File -FilePath 'public_ip.log'\""
  }
}*/


resource "null_resource" "log_public_ip" {
  depends_on = [aws_instance.my_instance]
  provisioner "local-exec" {
    command = "powershell.exe -Command \"Write-Output '${aws_instance.my_instance.public_ip}' | Out-File -FilePath 'public_ip.log'\""
  }
}






































resource "aws_security_group" "sg_ssh" {
  name_prefix = "${var.name_prefix}-sg-ssh"
  description = "Allow SSH traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



/*resource "aws_instance" "my_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.my_subnet.*.id[count.index % length(aws_subnet.my_subnet.*.id)]
  vpc_security_group_ids = [aws_security_group.sg_ssh.id]

  count         = var.instance_count

  tags = {
    Name = "${var.name_prefix}-instance-${count.index}"
  }
}*/

