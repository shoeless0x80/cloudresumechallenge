resource "aws_dynamodb_table" "visits" {
  name         = "${var.prefix}-visits"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = var.common_tags
}