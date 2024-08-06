
variable "image_name" {
  description  = "Image for container."
  type         = list 
  default      = ["nginx:latest", "httpd:latest"]
}

variable "container_name" {
   default  = "noname"
}
