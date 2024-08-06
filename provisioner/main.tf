
provider "aws" {
  region = "ap-south-1"
}
# Specify the EC2 details
resource "aws_instance" "example" {
  ami           = "ami-0ad21ae1d0696ad58"
  instance_type = "t2.micro"
  key_name      = "devops"

  provisioner "file" {
    source  = "test.conf"
    destination = "/tmp/myapp.conf"
}
  connection {
   type = "ssh"
   user = "ec2-user"
   private_key = file("devops.pem")
   host = self.public_ip
 }
}




# local-exec provisioner
#provisioner "local-exec" {
#  command = "echo aws_instance.example.private_ip >> private_ips.txt"
# }
#}
