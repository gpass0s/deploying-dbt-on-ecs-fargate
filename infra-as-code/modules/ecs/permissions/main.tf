data "aws_region" "aws_account_region" {}
data "aws_caller_identity" "aws_account" {}

locals {
  AWS_REGION     = data.aws_region.aws_account_region.name
  AWS_ACCOUNT_ID = data.aws_caller_identity.aws_account.account_id
}

resource "aws_iam_role" "iam_ecs_service_role" {
  name = "${var.RESOURCE_PREFIX}-role"
  tags = var.AWS_TAGS

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "iam_ecs_service_police" {
  name = "${var.RESOURCE_PREFIX}-profile-policy"
  role = aws_iam_role.iam_ecs_service_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": "${var.ECS_CLUSTER_ARN}",
            "Action": [
                "ec2:AttachNetworkInterface",
                "ec2:CreateNetworkInterface",
                "ec2:CreateNetworkInterfacePermission",
                "ec2:DeleteNetworkInterface",
                "ec2:DeleteNetworkInterfacePermission",
                "ec2:Describe*",
                "ec2:DetachNetworkInterface",
                "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
                "elasticloadbalancing:DeregisterTargets",
                "elasticloadbalancing:Describe*",
                "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
                "elasticloadbalancing:RegisterTargets"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role" "iam_ecs_task_execution_service_role" {
  name = "${var.RESOURCE_PREFIX}-task-execution-role"
  tags = var.AWS_TAGS

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "iam_ecs_task_execution_service_police" {

  name   = "${var.RESOURCE_PREFIX}-task-execution-profile-policy"
  role   = aws_iam_role.iam_ecs_task_execution_service_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": "*",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
        }
    ]
}
EOF
}


resource "aws_iam_role" "dbt-fargate-task-role" {
  name = "${var.RESOURCE_PREFIX}-dbt-fargate-task-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy" "dbt-fargate-task-policy" {

  name = "${var.RESOURCE_PREFIX}-dbt-fargate-task-policy"
  role = aws_iam_role.dbt-fargate-task-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:RunTask",
        "ecs:StopTask"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}


