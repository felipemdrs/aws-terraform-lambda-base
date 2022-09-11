resource "aws_kms_key" "my_kms_key" {
  description              = "s3 encription key"
  customer_master_key_spec = var.key_spec
  is_enabled               = var.enabled
  enable_key_rotation      = var.rotation_enabled

  tags = {
    Name = "aws-lambda-s3-kms"
  }
}

resource "aws_kms_alias" "my_kms_alias" {
  target_key_id = aws_kms_key.my_kms_key.key_id
  name          = "alias/${var.kms_s3_alias}"
}
