###################tf-plan artifact bucket #########################
resource "aws_s3_bucket" "teraform_plan_artifacts_bucket" {
  bucket = "tfplan-artifacts"
}

resource "aws_s3_bucket_versioning" "my_bucket_versioning" {
  bucket = aws_s3_bucket.teraform_plan_artifacts_bucket.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "teraform_plan_artifacts_bucket_pab" {
  bucket = aws_s3_bucket.teraform_plan_artifacts_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

########################################################################

###################tf-plan input bucket #########################
resource "aws_s3_bucket" "teraform_plan_input_bucket" {
  bucket = "tfplan-input-bucket"
}

resource "aws_s3_bucket_versioning" "tf_plan_input_bucket_versioning" {
  bucket = aws_s3_bucket.teraform_plan_input_bucket.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "teraform_plan_input_bucket_pab" {
  bucket = aws_s3_bucket.teraform_plan_input_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

########################################################################

###################tf-plan input bucket #########################
resource "aws_s3_bucket" "teraform_plan_output_bucket" {
  bucket = "tfplan-output-bucket"
  
}

resource "aws_s3_bucket_public_access_block" "teraform_plan_output_bucket_pab" {
  bucket = aws_s3_bucket.teraform_plan_output_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

########################################################################