resource aws_s3_bucket bucket {
    bucket = "shashvat-remote-backend-bucket"
    tags = {
      Name = "remote s3"
    }
}