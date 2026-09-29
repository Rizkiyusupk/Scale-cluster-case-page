resource "aws_dynamodb_table" "pipeline-history-table" {
  name         = "PipelineHistory"
  billing_mode = "PAY_PER_REQUEST" 

  hash_key  = "event_id"
  range_key = "timestamp"

  attribute {
    name = "event_id"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "N"
  }

  tags = {
    Name        = "pipeline-history"
    Environment = "learning"
  }
}
