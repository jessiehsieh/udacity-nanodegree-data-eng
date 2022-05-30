resource "aws_iam_policy" "s3_input_bucket_read_only_policy" {
  name        = "s3_input_bucket_read_only_policy"
  description = "Allows to read from the input bucket"
  
  tags = local.required_tags

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            "Sid": "ListObjectsInBucket",
            "Effect": "Allow",
            "Action": ["s3:ListBucket"],
            "Resource": [data.aws_s3_bucket.input_bucket.arn]
        },
        {
            "Sid": "AllObjectActions",
            "Effect": "Allow",
            "Action": "s3:GetObject*",
            "Resource": ["${data.aws_s3_bucket.input_bucket.arn}/*"]
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