resource "aws_iam_role" "iam_for_lambda" {
  name               = var.RESOURCE_NAME
  assume_role_policy = data.aws_iam_policy_document.lambda_role.json
  path               = "/service-role/"
}

data "aws_iam_policy_document" "lambda_role" {
  version = "2012-10-17"
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
    effect = "Allow"
    sid    = ""
  }
}

resource "aws_iam_role_policy" "iam_for_lambda_ecs_policy" {
  name   = var.RESOURCE_NAME
  role   = aws_iam_role.iam_for_lambda.id
  policy = data.aws_iam_policy_document.lambda_role_ecs_policy.json
}

data "aws_iam_policy_document" "lambda_role_ecs_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup"
    ]
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:log-group:/aws/lambda/${var.RESOURCE_NAME}:*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "ecs:RunTask"
    ]
    resources = var.ECS_TASK_DEFINITIONS_ARN
  }
  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = var.ROLES_TO_ASSUME_ARN
  }
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [var.SECRET_MANAGER_ARN]
  }
}
