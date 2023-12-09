output "install_python_dependencies" {
  value = null_resource.install_python_dependencies
}

output "file_name" {
  value = var.BUILD_SETTINGS["file_name"]
}

output "file_hash" {
  value = fileexists(var.BUILD_SETTINGS["file_name"]) ? filebase64sha256(var.BUILD_SETTINGS["file_name"]) : ""
}