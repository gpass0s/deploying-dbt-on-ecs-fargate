variable "PACKAGE_SETTINGS" {
  type = map(string)
  default = {
    "type"               = ""
    "lambda_script_path" = ""
    "folder_output_name" = ""
  }
}