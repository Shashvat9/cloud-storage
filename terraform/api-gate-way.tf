# resource "aws_api_gateway_rest_api" "cloud_storage_api" {
#   name        = "cloud-storage-api"
#   description = "API for cloud storage operations"
# }

# resource "aws_api_gateway_resource" "files" {
#   rest_api_id = aws_api_gateway_rest_api.cloud_storage_api.id
#   parent_id   = aws_api_gateway_rest_api.cloud_storage_api.root_resource_id
#   path_part   = "files"
# }

# resource "aws_api_gateway_method" "files_get" {
#   rest_api_id   = aws_api_gateway_rest_api.cloud_storage_api.id
#   resource_id   = aws_api_gateway_resource.files.id
#   http_method   = "GET"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_method" "files_post" {
#   rest_api_id   = aws_api_gateway_rest_api.cloud_storage_api.id
#   resource_id   = aws_api_gateway_resource.files.id
#   http_method   = "POST"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_method" "file_delete" {
#   rest_api_id   = aws_api_gateway_rest_api.cloud_storage_api.id
#   resource_id   = aws_api_gateway_resource.files.id
#   http_method   = "DELETE"
#   authorization = "NONE"
# }

