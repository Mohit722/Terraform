terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "3.0.2"
  }
 }
}
resource "docker_container" "container_id" {
   name  = var.container_name
   image = "nginx: latest"
   ports {
    internal = 80
    external = 80

 }
}
