resource "aws_dynamodb_table" "Lock-table" {
  name = "remote-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID" # hash key is like primery key

  attribute {
    name = "LockID" # this must me same it is case sensitive
    type = "S"
  }

  tags = {
    Name = "lock-table"
  }

}