
data "local_file" "build_script" {
  filename = "./modules/lambda-layer/build/build.sh"
}

#data "local_file" "resource_package" {
#  filename = fileexists(var.BUILD_SETTINGS["file_name"]) ? var.BUILD_SETTINGS["file_name"] : none
#}

resource "null_resource" "install_python_dependencies" {

  triggers = {
    # always        = uuid()
    # resource      = fileexists(data.local_file.resource_package.filename)
    requirements         = var.BUILD_SETTINGS["requirements"]
    requirements_content = fileexists(var.BUILD_SETTINGS["requirements"]) ? filebase64sha256(var.BUILD_SETTINGS["requirements"]) : var.BUILD_SETTINGS["requirements"]
    bash_script          = sha256(data.local_file.build_script.filename)
  }

  provisioner "local-exec" {
    command     = data.local_file.build_script.content
    interpreter = ["/bin/bash", "-c"]

    environment = {
      layer_name          = var.BUILD_SETTINGS["layer_name"]
      package_output_dir  = var.BUILD_SETTINGS["package_output_dir"]
      package_output_name = var.BUILD_SETTINGS["package_output_name"]
      requirements        = var.BUILD_SETTINGS["requirements"]
      runtime             = var.BUILD_SETTINGS["runtime"]
    }

  }

}