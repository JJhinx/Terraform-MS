data "aws_iam_policy_document" "assumerole" {
  statement {
    effect = "Allow"
    principals {
      type = "service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "LambdaIAM"
  assume_role_policy = data.aws_iam_policy_document.assumerole.json
}

