resource "aws_sqs_queue" "user-sqs" {
  name = "pentil_kuda"
  provider = aws
}

resource "aws_sqs_queue_policy" "example" {
  queue_url = aws_sqs_queue.user-sqs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "Cejuwdam"
      Effect = "Allow"
      Principal = {
        Service = "sns.amazonaws.com"
      }
      Action   = "SQS:SendMessage"
      Resource = aws_sqs_queue.user-sqs.arn
      Condition = {
        ArnLike = {
          "aws:SourceArn" = aws_sns_topic.user_updates.arn
        }
      }
    }]
  })
}
