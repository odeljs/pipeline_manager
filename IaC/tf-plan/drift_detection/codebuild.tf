resource "aws_codebuild_project" "tf_plan_codebuild" {
  name           = "tf_plan_project"
  description    = "used to run terraform plan"
  build_timeout  = 5
  queued_timeout = 5

  service_role = aws_iam_role.codebuild_admin_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }
  
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "NO_SOURCE"
    buildspec       = file("${path.root}/buildspecs/plan.yml")
  }

}
