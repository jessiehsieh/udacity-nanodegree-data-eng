/* 
######## Kept for backup purposes

data "aws_iam_policy_document" "allow_any_internal_access" {
  statement {
    sid = "Allow read and list only from the same account"
    principals {
      type        = "AWS"
      identifiers = ["${var.account_id}", "arn:aws:iam::${var.account_id}:role/aws-reserved/sso.amazonaws.com/eu-west-1/AWSReservedSSO_siCompliantAdmin_b76a4425d9fd6a7a",
        ]
    }

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.preprocessed_bucket.arn,
      "${aws_s3_bucket.preprocessed_bucket.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "allow_any_internal_access" {
  bucket = aws_s3_bucket.preprocessed_bucket.id
  policy = data.aws_iam_policy_document.allow_any_internal_access.json
}
*/