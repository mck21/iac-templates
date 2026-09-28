resource "aws_s3_bucket" "privado" {
  bucket = var.bucket_name

  tags = {
    Name = "Bucket Privado"
  }
}

resource "aws_s3_bucket_public_access_block" "privado" {
  bucket = aws_s3_bucket.privado.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
