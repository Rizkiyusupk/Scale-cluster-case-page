data "aws_iam_policy_document" "lambda-consumer-assume-role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda-consumer-role" {
  name               = "lamda-consumer-role"
  assume_role_policy = data.aws_iam_policy_document.lambda-consumer-assume-role.json
}

data "aws_iam_policy_document" "lambda-consumer-policy" {
  statement {
    effect    = "Allow"
    actions   = [  "sqs:ReceiveMessage", "sqs:DeleteMessage",
    "dynamodb:PutItem", "dynamodb:UpdateItem",
    "logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "Lambda-role-consumer-policy" {
  name        = "lambda-consumer-role-policy"
  description = "A Lambda policy"
  policy      = data.aws_iam_policy_document.lambda-consumer-policy.json
}

resource "aws_iam_role_policy_attachment" "lambda-consumer-role-attachment" {
  role       = aws_iam_role.lambda-consumer-role.name
  policy_arn = aws_iam_policy.Lambda-role-consumer-policy.arn

}
