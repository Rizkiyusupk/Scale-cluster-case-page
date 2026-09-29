resource "aws_cloudwatch_metric_alarm" "test" {
  alarm_name                = "terraform-test"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "Errors"
  namespace                 = "AWS/Lambda"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "This metric monitors Lambda"
  dimensions = {
    FunctionName = "lambda_function_name"
  }

  insufficient_data_actions = []
}
