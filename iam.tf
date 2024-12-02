data "aws_iam_policy_document" "assumerole" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "s3_permissions" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject", "s3:GetObject"]
    resources = [
      "arn:aws:s3:::buckie-the-bucket/*"  # Replace with your S3 bucket name
    ]
  }
}

resource "aws_iam_role" "lambda" {
  name               = "LambdaIAM"  # Specify the role name
  assume_role_policy = data.aws_iam_policy_document.assumerole.json

  tags = {
    Environment = "Production"  # Example of key-value pairs for tags
  }
}

resource "aws_iam_role_policy" "lambda_s3_policy" {
  name = "LambdaS3Policy"
  role = aws_iam_role.lambda.id

  policy = data.aws_iam_policy_document.s3_permissions.json
}