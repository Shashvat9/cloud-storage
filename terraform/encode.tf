resource "aws_iam_role" "encode_lambda_role" {
    name = "encode_lambda_role"
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

resource "aws_iam_role_policy_attachment" "encode_lamda_policy_attachment" {
    role       = aws_iam_role.encode_lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

data "archive_file" "dummy_lambda_package_encode" {
  type        = "zip"
  output_path = "${path.module}/dummy_lambda_enc.zip"

  source {
    content  = "exports.handler = async (event) => { console.log('This is a placeholder function. Real code is deployed by CI/CD.'); };"
    filename = "index.js"
  }
}

resource "aws_lambda_function" "encode_lambda" {
  function_name = "encode_lambda"
  role          = aws_iam_role.encode_lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  
  filename         = data.archive_file.dummy_lambda_package_encode.output_path
  source_code_hash = data.archive_file.dummy_lambda_package_encode.output_base64sha256

  vpc_config {
    subnet_ids         = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id]
    security_group_ids = [aws_security_group.put_lambda_sg.id]
  }

  tags = {
    Name        = "Encrypt Lambda Function"
    Environment = "Production"
  }
  
}