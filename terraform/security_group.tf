resource "aws_security_group" "db_security_group" {
  name        = "cloud_storage_db_sg"
  description = "Security group for Cloud Storage database"
  vpc_id      = aws_vpc.cloud_storage_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.private_subnet_a.cidr_block, aws_subnet.private_subnet_b.cidr_block, aws_subnet.public_subnet.cidr_block]
    # security_groups = [aws_security_group.get_lambda_sg.id, aws_security_group.put_lambda_sg.id]
    description = "Allow MySQL access from private subnets"
  }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name        = "Cloud Storage DB Security Group"
        Environment = "Production"
    }
}

resource "aws_security_group" "put_lambda_sg" {
  name        = "put_lambda_sg"
  description = "Security group for Lambda function to access RDS and S3 bucket"
  vpc_id      = aws_vpc.cloud_storage_vpc.id

  egress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound HTTPS traffic"
  }

  egress{
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    security_groups = [aws_security_group.db_security_group.id]
    description = "Allow outbound MySQL traffic to DB security group"
  } 
}

resource "aws_security_group" "get_lambda_sg" {
  name        = "get_lambda_sg"
  description = "Security group for Lambda function to access RDS and S3 bucket"
  vpc_id      = aws_vpc.cloud_storage_vpc.id

  egress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound HTTPS traffic"
  }

  egress{
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    security_groups = [aws_security_group.db_security_group.id]
    description = "Allow outbound MySQL traffic to DB security group"
  } 
}