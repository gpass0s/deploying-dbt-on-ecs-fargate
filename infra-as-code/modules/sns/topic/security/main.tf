resource "aws_sns_topic_policy" "policy" {
  arn    = var.TOPIC_ARN
  policy = data.aws_iam_policy_document.topic_policy.json
}

data "aws_iam_policy_document" "topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic",
      "SNS:Subscribe",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish",
      "SNS:Receive",
    ]

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      var.TOPIC_ARN,
    ]

    sid = "__default_statement_ID"
  }
}