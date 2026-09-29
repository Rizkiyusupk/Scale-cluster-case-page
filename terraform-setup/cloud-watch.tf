resource "aws_cloudwatch_log_group" "test" {
  name = "/aws/lambda/lambda_function_consumer"
  retention_in_days = 5
  tags = {
    Environment = "production"
    Application = "serviceA"
  }
}
