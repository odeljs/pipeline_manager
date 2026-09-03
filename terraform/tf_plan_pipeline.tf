resource "aws_codepipeline" "codepipeline" {
  name           = "tf-plan-pipeline"
  role_arn       = aws_iam_role.codepipeline_role.arn
  pipeline_type  = "V2"
  execution_mode = "PARALLEL"

  artifact_store {
    location = aws_s3_bucket.teraform_plan_artifacts_bucket.bucket
    type     = "S3"

    encryption_key {
      id   = data.aws_kms_key.aws_managed_s3.arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
      output_artifacts = ["source_output"]

       configuration = {
        S3Bucket                = aws_s3_bucket.teraform_plan_input_bucket.bucket
        S3ObjectKey             = "payload.zip"
        PollForSourceChanges    = "false" 
      }
    }
  }

  stage {
    name = "Terraform_Plan"

    action {
      name             = "terraform_plan"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "test"
      }
    }
  }
}

