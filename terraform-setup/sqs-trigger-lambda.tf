resource "aws_lambda_event_source_mapping" "sqs-trigger" {
  event_source_arn = aws_sqs_queue.user-sqs.arn
  function_name    = aws_lambda_function.lambda-function-consumer.arn
  batch_size       = 10

  scaling_config {
    maximum_concurrency = 100
  }
}
