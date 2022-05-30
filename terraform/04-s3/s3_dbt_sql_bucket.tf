resource "aws_s3_bucket" "dbt_sql_bucket" {
  bucket = "${var.stage}-dbt-sql-bucket"

  versioning {
    enabled = true
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
  tags = local.required_tags
}


