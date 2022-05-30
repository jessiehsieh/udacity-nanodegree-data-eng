data "aws_iam_policy_document" "sfn_role_policy" {
  statement {
    effect                  = "Allow"
    principals {
      type                  = "Service"
      identifiers           = ["states.amazonaws.com"]
    }
    actions                 = ["sts:AssumeRole"]
  }
}


resource "aws_iam_role" "sfn_execution_role" {
  name                      = "role_Step_Function_ExecutionRole"
  assume_role_policy        = data.aws_iam_policy_document.sfn_role_policy.json
  tags                      = local.required_tags
}


resource "aws_iam_role_policy_attachment" "sfn-execution-role-policy-attachment" {
  role       = aws_iam_role.sfn_execution_role.name
  policy_arn = aws_iam_policy.sfn_execution_policy.arn

}
