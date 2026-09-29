resource "aws_lambda_function" "lambda-function" {
  filename      = "${path.module}/lambda_function.zip"
  function_name = "lambda_function"
  role          = aws_iam_role.role.arn
  handler       = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("${path.module}/lambda_function.zip")

  runtime = "python3.12"

  environment {
    variables = {
      ENVIRONMENT = "production"
      LOG_LEVEL   = "info"
    }
  }

  tags = {
    Environment = "production"
    Application = "example"
  }
}
