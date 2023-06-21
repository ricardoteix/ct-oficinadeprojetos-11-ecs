resource "random_string" "random" {
  length  = 4
  special = false
  upper   = false
  numeric  = true
}

resource "aws_s3_bucket" "projeto-static" {
  bucket = "${var.nome-bucket}-${random_string.random.result}"

  force_destroy = true # CUIDADO! Em um ambiente de produção você pode não querer apagar tudo no bucket
  
  tags = {
    Name = var.tag-base
  }
}

resource "aws_s3_bucket_cors_configuration" "projeto" {
  bucket = aws_s3_bucket.projeto-static.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE", "HEAD"]
    allowed_origins = ["http://${aws_lb.openproject.dns_name}"]
    expose_headers  = []
    max_age_seconds = 3000
  }
  
}

resource "aws_s3_bucket_lifecycle_configuration" "projeto-static-config" {
  bucket = aws_s3_bucket.projeto-static.id

  rule {
    id = aws_s3_bucket.projeto-static.bucket

    status = "Enabled"

    transition {
      days          = 1
      storage_class = "INTELLIGENT_TIERING"
    }

  }

}