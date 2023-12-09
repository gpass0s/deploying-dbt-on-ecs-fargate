locals {
  RESOURCE_NAME = "${var.PROJECT_NAME}-${var.ENV}-${var.RESOURCE_SUFFIX}"
  RESOURCE_FILE = "${var.PACKAGE_OUTPUT_DIR}/${var.PACKAGE_OUTPUT_NAME}.zip"
}

# IMPORTANT INFORMATION
# The lambda layers will only be rebuild if you change the contents of the requirement file or of the build script

module "build" {
  source = "./build"

  BUILD_SETTINGS = {
    layer_name          = local.RESOURCE_NAME
    file_name           = local.RESOURCE_FILE
    package_output_dir  = var.PACKAGE_OUTPUT_DIR
    package_output_name = var.PACKAGE_OUTPUT_NAME
    requirements        = var.REQUIREMENTS
    runtime             = var.PYTHON_RUNTIME
  }
}

resource "aws_lambda_layer_version" "python-layer" {
  layer_name          = local.RESOURCE_NAME
  filename            = module.build.file_name
  source_code_hash    = module.build.file_hash
  compatible_runtimes = [var.PYTHON_RUNTIME]
  depends_on          = [module.build]
}