resource "aws_s3_bucket" "bucket" {
  bucket        = "felipemdrs-lambdas-deploys"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_encryption" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_kms_key.key_id
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_lifecycle_configuration" "s3_lifecycle" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    id = "lambdas-deploys-s3-rule"
    filter {
      prefix = "logs/"
    }
    status = "Enabled"
    expiration {
      days = 7
    }
  }
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.bucket.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "${data.aws_caller_identity.current.arn}"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.bucket.bucket}"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "${data.aws_caller_identity.current.arn}"
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::${aws_s3_bucket.bucket.bucket}/*"
        }
    ]
}
POLICY
}