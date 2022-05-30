resource "aws_s3_bucket" "preprocessed_bucket" {
  bucket = "${local.required_tags["stage"]}-data-preprocessed-bucket"
  acl    = "private"

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
                Name = "Preprocessed data bucket for Redshift ingest - No real data allowed"
                }
              )
}
