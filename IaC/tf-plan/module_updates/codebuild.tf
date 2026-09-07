resource "aws_codebuild_project" "central_tf_batch" {
  name         = "centralized-terraform-batch-tester"
  service_role = aws_iam_role.codebuild_batch_execution.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  # Orchestrates parallel execution nodes across a matrix
  build_batch_config {
    service_role    = aws_iam_role.codebuild_batch_execution.arn
    timeout_in_mins = 30
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type      = "NO_SOURCE" # Code is checked out dynamically using Git within buildspec
    buildspec = file("${path.module}/buildspec-batch.yml")
  }
}
