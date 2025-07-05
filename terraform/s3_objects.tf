// terraform/s3_objects.tf

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.site.id
  key          = "index.html"
  source       = "${path.module}/../frontend/index.html"
  source_hash  = filemd5("${path.module}/../frontend/index.html")
  content_type = "text/html"
}

resource "aws_s3_object" "styles" {
  bucket       = aws_s3_bucket.site.id
  key          = "styles.css"
  source       = "${path.module}/../frontend/styles.css"
  source_hash  = filemd5("${path.module}/../frontend/styles.css")
  content_type = "text/css"
}

resource "aws_s3_object" "script" {
  bucket       = aws_s3_bucket.site.id
  key          = "script.js"
  source       = "${path.module}/../frontend/script.js"
  source_hash  = filemd5("${path.module}/../frontend/script.js")
  content_type = "application/javascript"
}