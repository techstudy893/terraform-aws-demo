locals {
  bucket = "${var.project}-${random_id.suffix.hex}"
}

resource "random_id" "suffix" {
  byte_length = 3
}

resource "aws_s3_bucket" "site" {
  bucket = local.bucket
  tags   = { Name = "${var.project}-site" }
}

# Keep object ownership consistent (no ACLs)
resource "aws_s3_bucket_ownership_controls" "o" {
  bucket = aws_s3_bucket.site.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Option A (default, safer): keep the bucket PRIVATE.
# Block public access so you don't accidentally expose objects.
resource "aws_s3_bucket_public_access_block" "private" {
  bucket                  = aws_s3_bucket.site.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Optional static website config (this just enables the endpoint;
# it does NOT make content public by itself).
resource "aws_s3_bucket_website_configuration" "w" {
  bucket = aws_s3_bucket.site.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.site.id
  key          = "index.html"
  content      = "<h1>Hello from S3</h1>"
  content_type = "text/html"
}
