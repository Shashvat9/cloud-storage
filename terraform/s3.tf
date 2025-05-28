resource "aws_s3_bucket" "cloud_storage_bucket" {
  bucket = "cloud-storage-28-05-2025"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "Cloud Storage Bucket"
  }
}