provider "aws" {
  region = "ap-south-1"
}

# Reference the existing security group
data "aws_security_group" "existing_sg" {
  id = "sg-0a4b86efefd9999b7"  # Replace with your existing security group ID
}

# specify the EC2 detials
resource "aws_instance" "node2" {
  ami           = "ami-0ad21ae1d0696ad58"
  instance_type = "t2.micro"
  key_name      = "devops"
  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]
 
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get-update",
      "sudo apt-get install -y python3"  
]

    connection {
       type  = "ssh"
       user  = "ubuntu"
       private_key = file("${path.module}/devops.pem")
       host        = self.public_ip
 }
}

 tags = {
  Name = "Node2"
 }
}

output "node2_ip" {
 value = aws_instance.node2.public_ip
}  

