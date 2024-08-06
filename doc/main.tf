# Specify the Docker host
terraform{
  required_providers{
    docker = {
      source = "kreuzwerker/docker"
      version = "3.0.2"
   }
 }
}
 
provider "docker" {
  host = "unix:///var/run/docker.sock"
  #host = "ssh://user@remote-host:22"
  #host = "tcp://127.0.0.1:2376/"
}

# Download the lastest Nginx Image
resource "docker_image" "myimage" {
  name = var.image_name[1]
}

# Start the Container
resource "docker_container" "mycontainer" {
  name  = "var.container_name"
  image =  docker_image.myimage.image_id
  ports {
    internal = "80"
    external = "80"

  }
}
