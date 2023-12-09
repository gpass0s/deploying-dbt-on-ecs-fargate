#Creates a log group for lambda functions
resource "aws_cloudwatch_log_group" "log_for_ecs_cluster" {
  name              = "/aws/ecs/${var.LOGGING_SETTINGS["ecs_cluster_name"]}"
  retention_in_days = var.LOGGING_SETTINGS["log_retention_in_days"]
}