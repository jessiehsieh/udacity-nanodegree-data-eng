resource "aws_s3_bucket" "input_bucket" {
  bucket = "${local.required_tags["stage"]}-data-input-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    # change back to true once we receive real data
    enabled = false

    noncurrent_version_transition {
      days          = 30
      storage_class = "ONEZONE_IA"
    }

    noncurrent_version_transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = data.aws_kms_key.external_master_encryption_key.id
        sse_algorithm     = "aws:kms"
      }
      bucket_key_enabled = true
    }
  }

  tags = merge(local.required_tags,
    {
      Name = "Contract Data Upload Destination - No real data allowed"
    }
  )
}