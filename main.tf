resource "aws_kms_key" "mykey" {
    description             = "This key is used to encrypt bucket objects"
    deletion_window_in_days = 10
}

resource "aws_s3_bucket" "mybucket" {
    bucket = var.bucket_name

    tags = {
    terraform = true
    Name        = var.bucket_name
    Environment = var.Environment
    }
}

resource "aws_s3_bucket_acl" "acl" {
    bucket = aws_s3_bucket.mybucket.id
    acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning" {
    bucket = aws_s3_bucket.mybucket.id
    versioning_configuration {
    status = "Enabled"
}
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
    bucket = aws_s3_bucket.mybucket.bucket

    rule {
    apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm     = "aws:kms"
        }
    bucket_key_enabled = true
    }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "policy" {
    bucket = aws_s3_bucket.mybucket.id
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
        "${aws_s3_bucket.mybucket.arn}",
        "${aws_s3_bucket.mybucket.arn}/*"
      ]
    }
  ]
}
EOF
}