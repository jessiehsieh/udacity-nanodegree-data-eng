resource "aws_iam_policy" "s3_redshift_log_policy" {
  name        = "s3_redshift_log_policy"
  description = "Put logs into the s3 bucket"

  tags = local.required_tags

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid" : "redshiftAccessToS3bucket",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetBucketAcl"
        ],
        "Resource" : [
          data.aws_s3_bucket.redshift_audit_logs_bucket.arn,
          "${data.aws_s3_bucket.redshift_audit_logs_bucket.arn}/*"
        ]
      }, 
      {
        "Sid": "KMSAccess",
        "Action": [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ],
        "Effect": "Allow",
        "Resource": data.aws_kms_key.external_master_encryption_key.arn
      }
    ]
  })
}
