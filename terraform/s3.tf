###################tf-plan artifact bucket #########################
resource "aws_s3_bucket" "teraform_plan_artifacts_bucket" {
  bucket = "tfplan-artifacts"
}

resource "aws_s3_bucket_public_access_block" "teraform_plan_artifacts_bucket_pab" {
  bucket = aws_s3_bucket.teraform_plan_artifacts_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

########################################################################

###################tf-plan artifact bucket #########################
resource "aws_s3_bucket" "teraform_plan_input_bucket" {
  bucket = "tfplan-input-bucket"
}

resource "aws_s3_bucket_public_access_block" "teraform_plan_input_bucket_pab" {
  bucket = aws_s3_bucket.teraform_plan_input_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

########################################################################