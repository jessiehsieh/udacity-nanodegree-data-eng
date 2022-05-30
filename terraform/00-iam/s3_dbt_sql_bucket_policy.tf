resource "aws_iam_policy" "s3_dbt_sql_bucket_policy" {
  name        = "s3_dbt_sql_bucket_policy"
  description = "Allows to read and write from/to the dbt_sql bucket"
  
  tags = local.required_tags

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            "Sid": "ListObjectsInBucket",
            "Effect": "Allow",
            "Action": ["s3:ListBucket"],
            "Resource": [data.aws_s3_bucket.dbt_sql_bucket.arn]
        },
        {
            "Sid": "AllObjectActions",
            "Effect": "Allow",
            "Action": "s3:*Object*",
            "Resource": ["${data.aws_s3_bucket.dbt_sql_bucket.arn}/*"]
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
