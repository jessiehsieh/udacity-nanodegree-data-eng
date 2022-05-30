/* 
######## Kept for backup purposes

data "aws_iam_policy_document" "allow_access_read_and_upload" {
  statement {
    sid = "Allow read and list only from the same account"
    principals {
      type = "AWS"
      identifiers = ["${var.account_id}", "arn:aws:iam::${var.account_id}:role/aws-reserved/sso.amazonaws.com/eu-west-1/AWSReservedSSO_siCompliantAdmin_b76a4425d9fd6a7a",
      ]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.input_bucket.arn,
      "${aws_s3_bucket.input_bucket.arn}/*",
    ]
  }

  statement {
    sid = "Allow files to be provided into the bucket"
    principals {
      type        = "AWS"
      identifiers = ["${var.file_provider_account_id}"]
      # "arn:aws:iam::${var.file_provider_account_id}:role/${var.rolename}",
      # "arn:aws:iam::${var.file_provider_account_id}:user/${var.username}"
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
      "s3:DeleteObject"
    ]

    resources = [
      aws_s3_bucket.input_bucket.arn,
      "${aws_s3_bucket.input_bucket.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "allow_access_read_and_upload" {
  bucket = aws_s3_bucket.input_bucket.id
  policy = data.aws_iam_policy_document.allow_access_read_and_upload.json
}
*/