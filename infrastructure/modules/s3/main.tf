resource "aws_s3_bucket" "rails" {

  bucket = "${local.name_prefix}-uploads"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-uploads"
    }
  )
}

resource "aws_s3_bucket_versioning" "rails" {

  bucket = aws_s3_bucket.rails.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "rails" {

  bucket = aws_s3_bucket.rails.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "rails" {

  bucket = aws_s3_bucket.rails.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}