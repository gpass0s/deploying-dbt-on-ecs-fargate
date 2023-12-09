data "archive_file" "script" {
  type             = var.PACKAGE_SETTINGS["type"]
  source_file      = var.PACKAGE_SETTINGS["lambda_script_path"]
  output_file_mode = "0766"
  output_path      = "../../utils/lambda-deployment-packages/${var.PACKAGE_SETTINGS["folder_output_name"]}.${var.PACKAGE_SETTINGS["type"]}"
}