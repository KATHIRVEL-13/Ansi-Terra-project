provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ec2_instance" {
  count         = var.number_of_instances
  ami           = var.ami_id
  subnet_id     = var.subnet_id
  instance_type = var.instance_type
  key_name      = var.ami_key_pair_name
  security_groups = ["sg-0767dca27feb3e46c"]
  tags = {
    Name = "${var.instance_name}-${count.index + 1}"  # Append unique index to instance name
  }

  root_block_device {
    volume_size = 25  # Set the storage size to 25 GiB
  }
}

resource "null_resource" "configure_ssh" {
  count = var.number_of_instances

  connection {
    type        = "ssh"
    host        = aws_instance.ec2_instance[count.index].public_ip
    user        = "ubuntu"
    private_key = file("/home/ubuntu/T/DevOps.pem")
  }

  provisioner "file" {
    source      = "/home/ubuntu/.ssh/id_ed25519.pub"
    destination = "/home/ubuntu/id_ed25519.pub"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ~/.ssh",
      "cat /home/ubuntu/id_ed25519.pub >> ~/.ssh/authorized_keys",
      "chmod 700 ~/.ssh",
      "chmod 600 ~/.ssh/authorized_keys"
    ]
  }

  depends_on = [aws_instance.ec2_instance, null_resource.disable_strict_host_key_checking]
}
resource "null_resource" "disable_strict_host_key_checking" {
  count = var.number_of_instances

  connection {
    type        = "ssh"
    host        = aws_instance.ec2_instance[count.index].public_ip
    user        = "ubuntu"
    private_key = file("/home/ubuntu/T/DevOps.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ~/.ssh",
      "echo 'Host *' >> ~/.ssh/config",
      "echo '  StrictHostKeyChecking no' >> ~/.ssh/config",
      "echo '  UserKnownHostsFile=/dev/null' >> ~/.ssh/config",
      "echo '  LogLevel ERROR' >> ~/.ssh/config" # Suppress warnings
    ]
  }

  depends_on = [aws_instance.ec2_instance]
}

output "vm_info" {
  value = { for idx, instance in aws_instance.ec2_instance : "${instance.tags.Name}" => instance.public_ip }
}

