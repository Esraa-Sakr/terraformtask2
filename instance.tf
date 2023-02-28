/*resource "aws_instance" "my_instance" {
  ami = "ami-0557a15b87f6559cf"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  subnet_id = aws_subnet.my_subnet[*].id[count.index % length(aws_subnet.my_subnet.*.id)]
  key_name = var.key_pair_name
  tags = {
    Name = "my-instance"
  }
}*/

resource "aws_security_group" "my_security_group" {
  name_prefix = "my-security-group"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "my-security-group"
  }
}

locals {
  public_ip  = aws_instance.my_instance.public_ip
  private_ip = aws_instance.my_instance.private_ip
}

resource "null_resource" "capture_screenshot" {
  provisioner "local-exec" {
    command = "powershell.exe -Command \"Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.Screen]::Capture([System.Windows.Forms.Screen]::PrimaryScreen.Bounds).Save('screenshot.jpg', 'JPEG')\""
  }
  depends_on = [aws_instance.my_instance]
}

/*resource "null_resource" "log_private_ips" {
  provisioner "local-exec" {
    command = "powershell.exe -Command \"Write-Output '${join("\n", local.private_ip)}' | Out-File -FilePath 'private_ips.log'\""
  }
  depends_on = [aws_instance.my_instance]
}*/


/*resource "aws_instance" "my_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair_name
  subnet_id     = aws_subnet.my_subnet[*].id[count.index % length(aws_subnet.my_subnet.*.id)]

  provisioner "local-exec" {
    command = "aws ec2 get-console-screenshot --instance-id ${self.id} --output text > screenshot_${self.id}.txt"
  }

  tags = {
    Name = "My instance"
  }
}*/

resource "aws_instance" "my_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.${var.t2}"

  subnet_id              = aws_subnet.my_subnet.*.id[0]
  vpc_security_group_ids = [aws_security_group.sg_ssh.id]
  key_name               = var.my-keypair
  tags                   = local.common_tags

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install apache2
              echo "Hello World!" > index.html
              nohup busybox httpd -f -p ${var.web_server_port} &
              EOF
}




locals {
  common_tags = {
    // ...
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


resource "aws_eip" "my_eip" {
  vpc = true
}





