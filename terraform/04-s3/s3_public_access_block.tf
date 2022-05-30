resource "aws_s3_bucket_public_access_block" "input_bucket" {
  bucket = aws_s3_bucket.input_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_public_access_block" "preprocessed_bucket" {
  bucket = aws_s3_bucket.preprocessed_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "redshift_audit_logs_bucket" {
  bucket = aws_s3_bucket.redshift_audit_logs_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "dbt_sql_bucket" {
  bucket = aws_s3_bucket.dbt_sql_bucket.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}
