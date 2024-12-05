#Lambda
# Lambda Function
resource "aws_lambda_function" "file_upload_lambda" {
  function_name = "FileUploadFunction"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda.arn
  handler       = "lambda_function.lambda_handler"

  # Path to your deployment package (ZIP file)
  filename = "lambda_function.zip"

  environment {
    variables = {
      S3_BUCKET = aws_s3_bucket.Buckie.id
    }
  }
}

# API Gateway
resource "aws_api_gateway_rest_api" "upload_api" {
  name = "FileUploadAPI"
}

resource "aws_api_gateway_resource" "upload_resource" {
  rest_api_id = aws_api_gateway_rest_api.upload_api.id
  parent_id   = aws_api_gateway_rest_api.upload_api.root_resource_id
  path_part   = "upload"
}

resource "aws_api_gateway_method" "upload_method" {
  rest_api_id   = aws_api_gateway_rest_api.upload_api.id
  resource_id   = aws_api_gateway_resource.upload_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.file_upload_lambda.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.upload_api.execution_arn}/*/*"
}

resource "aws_api_gateway_integration" "upload_integration" {
  rest_api_id             = aws_api_gateway_rest_api.upload_api.id
  resource_id             = aws_api_gateway_resource.upload_resource.id
  http_method             = aws_api_gateway_method.upload_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.file_upload_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "upload_deployment" {
  rest_api_id = aws_api_gateway_rest_api.upload_api.id
  depends_on  = [aws_api_gateway_integration.upload_integration]
}

resource "aws_api_gateway_stage" "name" {
  deployment_id = aws_api_gateway_deployment.upload_deployment.id
  stage_name  = "prod"
  rest_api_id = aws_api_gateway_rest_api.upload_api.id
}

# Output the API endpoint URL
output "api_endpoint" {
  value = "https://${aws_api_gateway_rest_api.upload_api.id}.execute-api.${var.region}.amazonaws.com/prod/upload"
}

