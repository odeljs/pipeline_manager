data "aws_codestarconnections_connection" "code_connection" {
  arn = var.code_connection_arn
}

data "aws_kms_key" "aws_managed_s3" {
  key_id = "alias/aws/s3"
}