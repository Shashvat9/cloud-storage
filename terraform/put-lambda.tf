resource "aws_iam_role" "add_s3_lambda_role" {
  name = "add_s3_lambda_role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

data "aws_iam_policy_document" "add_s3_lambda_policy" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
    ]
    resources = [
        "${aws_s3_bucket.cloud_storage_bucket.arn}/*",
        aws_s3_bucket.cloud_storage_bucket.arn
    ]
  }
}

resource "aws_iam_role_policy_attachment" "ingation_role_policy_attachment" {
  role       = aws_iam_role.add_s3_lambda_role.name
  
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_policy" "add_s3_lambda_policy" {
  name        = "add_s3_lambda_policy"
  description = "Policy for Lambda to access S3 bucket"
  policy      = data.aws_iam_policy_document.add_s3_lambda_policy.json 
}

resource "aws_iam_role_policy_attachment" "add_s3_lambda_policy_attachment" {
  role       = aws_iam_role.add_s3_lambda_role.name
  policy_arn = aws_iam_policy.add_s3_lambda_policy.arn
}

data "archive_file" "dummy_lambda_package_put" {
  type        = "zip"
  output_path = "${path.module}/dummy_lambda_put.zip"

  source {
    content  = "exports.handler = async (event) => { console.log('This is a placeholder function. Real code is deployed by CI/CD.'); };"
    filename = "index.js"
  }
}

resource "aws_lambda_function" "put_s3_object" {
  function_name = "put_s3_object"
  role          = aws_iam_role.add_s3_lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  
  filename         = data.archive_file.dummy_lambda_package_put.output_path
  source_code_hash = data.archive_file.dummy_lambda_package_put.output_base64sha256

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.cloud_storage_bucket.bucket
    }
  }

  vpc_config {
    subnet_ids         = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id]
    security_group_ids = [aws_security_group.put_lambda_sg.id]
  }

  tags = {
    Name        = "Put S3 Object Lambda Function"
    Environment = "Production"
  }
  
}