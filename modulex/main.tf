
module "image" {
  source = "./modules/image"
    image_name = var.rootimage_name
}

module "container" {
  source         = "./modules/container"
   image_name          = module.image.image_out   # module.modulename.outputvariablename
   container_name = var.rootcontainer_name
}

