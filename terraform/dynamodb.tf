resource "aws_dynamodb_table" "visits" {
  name         = "${var.prefix}-visits"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }

  tags = var.common_tags
}