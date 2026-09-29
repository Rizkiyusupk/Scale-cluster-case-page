resource "aws_lambda_function" "lambda-function-consumer" {
  filename          = "${path.module}/lambda_function_consumer.zip"
  function_name     = "lambda_function_consumer"
  role              = aws_iam_role.lambda-consumer-role.arn
  handler           = "lambda_function_consumer.lambda_handler"
  source_code_hash  = filebase64sha256("${path.module}/lambda_function_consumer.zip")
  runtime           = "python3.12"
  timeout           = 10

  environment {
    variables = {
      TELEGRAM_BOT_TOKEN_JAKARTA = var.telegram_bot_token_site_jakarta
      TELEGRAM_CHAT_ID_JAKARTA   = var.telegram_chat_id_jakarta
      TELEGRAM_BOT_TOKEN_BANDUNG = var.telegram_bot_token_site_bandung
      TELEGRAM_CHAT_ID_BANDUNG   = var.telegram_chat_id_bandung
    }
  }
  tags = {
    Environment = "production"
    Application = "example"
  }
}

variable "telegram_bot_token_site_jakarta" {
  type      = string
  sensitive = true
}

variable "telegram_chat_id_jakarta" {
  type      = string
  sensitive = true
}

variable "telegram_bot_token_site_bandung" {
  type      = string
  sensitive = true
}

variable "telegram_chat_id_bandung" {
  type      = string
  sensitive = true
}
