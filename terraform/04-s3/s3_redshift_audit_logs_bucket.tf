resource "aws_s3_bucket" "redshift_audit_logs_bucket" {
  bucket = "${local.required_tags["stage"]}-redshift-audit-logs-bucket"
  acl    = "private"

  versioning {
    enabled = false
  }

  lifecycle_rule {
    enabled = true

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
      Name = "Bucket used to store Redshift audit logs"
    }
  )
}

