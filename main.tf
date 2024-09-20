provider "aws" {
  region = "ap-south-1"
}

# Variables
variable "JenkinsAMI" {
  description = "AMI for Jenkins Master and Slave"
  default     = "ami-0522ab6e1ddcc7055"  # Replace with a valid AMI ID for your region
}

variable "InstanceType" {
  description = "Instance type for Jenkins Master and Slave"
  default     = "t2.micro"
}

variable "KeyPair" {
  description = "SSH Key Pair"
  default     = "devops"
}

variable "SecurityGroupID" {
  description = "The ID of the existing security group to associate with the instances"
  default     = "sg-0a4b86efefd9999b7"  # Your existing security group ID
}

variable "User" {
  description = "The default user for SSH access"
  default     = "ubuntu"
}

# Jenkins Master
resource "aws_instance" "jenkins_master" {
  ami                    = var.JenkinsAMI
  instance_type          = var.InstanceType
  key_name               = var.KeyPair
  vpc_security_group_ids = [var.SecurityGroupID]

  tags = {
    Name = "JenkinsMaster"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install -y openjdk-8-jdk
    wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
    sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    sudo apt update
    sudo apt install -y jenkins
    sudo systemctl start jenkins

    # Generate SSH key on master
    ssh-keygen -t rsa -N "" -f /home/ubuntu/.ssh/id_rsa
    chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa /home/ubuntu/.ssh/id_rsa.pub
  EOF

  provisioner "local-exec" {
    command = "echo 'Jenkins Master created and started'"
  }
}

# Jenkins Slave
resource "aws_instance" "jenkins_slave" {
  ami                    = var.JenkinsAMI
  instance_type          = var.InstanceType
  key_name               = var.KeyPair
  vpc_security_group_ids = [var.SecurityGroupID]

  depends_on = [aws_instance.jenkins_master]   # Ensure Master is created first

  tags = {
    Name = "JenkinsSlave"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install -y openjdk-8-jdk
    sudo mkdir -p /home/ubuntu/.ssh
    sudo chmod 700 /home/ubuntu/.ssh
  EOF

  provisioner "local-exec" {
    command = "echo 'Jenkins Slave created, waiting for 60 seconds...'; sleep 60"
  }


# SSH Setup Between Jenkins Master and Slave

  provisioner "remote-exec" {
    inline = [
      "echo 'Passwordless SSH setup between Master and Slave completed'",
      "scp -o StrictHostKeyChecking=no -i /etc/ansible/devops.pem ubuntu@${aws_instance.jenkins_master.public_ip}:/home/ubuntu/.ssh/id_rsa.pub /home/ubuntu/.ssh/authorized_keys",
      "sudo chmod 600 /home/ubuntu/.ssh/authorized_keys",
      "sudo chown ubuntu:ubuntu /home/ubuntu/.ssh/authorized_keys"
    ]

    connection {
      type        = "ssh"
      user        = var.User
      private_key = file("/etc/ansible/devops.pem")
      host        = aws_instance.jenkins_slave.public_ip  # Connect from master
    }
  }

  # Test passwordless SSH connection from master to slave
  provisioner "remote-exec" {
    inline = [
      "echo 'Testing SSH connection from master to slave'",
      "ssh -o StrictHostKeyChecking=no -i /etc/ansible/devops.pem ubuntu@${aws_instance.jenkins_slave.public_ip} 'echo SSH connection successful'"
    ]

    connection {
      type        = "ssh"
      user        = var.User
      private_key = file("/etc/ansible/devops.pem")
      host        = aws_instance.jenkins_slave.public_ip
    }
  }
}

# Outputs
output "jenkins_master_public_ip" {
  value = aws_instance.jenkins_master.public_ip
}

output "jenkins_slave_public_ip" {
  value = aws_instance.jenkins_slave.public_ip
}
