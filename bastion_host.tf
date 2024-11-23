resource "tls_private_key" "bastion_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion-key"
  public_key = tls_private_key.bastion_key.public_key_openssh
}

resource "local_file" "bastion_key_pem" {
  content  = tls_private_key.bastion_key.private_key_pem
  filename = "${path.module}/bastion-key.pem"

  # Set appropriate permissions to 600 (useful if deploying on Unix systems)
  file_permission = "0600"
}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public[0].id
  key_name      = aws_key_pair.bastion_key.key_name

  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    echo '${tls_private_key.asg_key.private_key_pem}' > /home/ec2-user/asg-key.pem
    chown ec2-user:ec2-user /home/ec2-user/asg-key.pem
    chmod 600 /home/ec2-user/asg-key.pem
  EOF
  depends_on = [tls_private_key.asg_key]

  tags = {
    Name = "Bastion Host"
  }
}


data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


resource "tls_private_key" "asg_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "asg_key" {
  key_name   = "asg-key"
  public_key = tls_private_key.asg_key.public_key_openssh
}

resource "local_file" "asg_key_pem" {
  content  = tls_private_key.asg_key.private_key_pem
  filename = "${path.module}/asg-key.pem"
  file_permission = "0600"
}

resource "null_resource" "wait_for_bastion" {
  depends_on = [aws_instance.bastion]

  connection {
    type        = "ssh"
    host        = aws_instance.bastion.public_ip
    user        = "ec2-user"
    private_key = tls_private_key.bastion_key.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "echo Bastion host is ready and reachable.",
    ]
  }
}


resource "null_resource" "remove_local_key" {
  depends_on = [null_resource.wait_for_bastion]

  provisioner "local-exec" {
    command = "rm -f ${local_file.asg_key_pem.filename}"
  }
}
