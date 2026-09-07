resource "aws_iam_role" "eventbridge_to_codebuild" {
  name = "eventbridge-to-codebuild-batch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "events.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "eventbridge_invoke" {
  name = "eventbridge-invoke-codebuild-batch-policy"
  role = aws_iam_role.eventbridge_to_codebuild.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "codebuild:StartBuild"
      Resource = aws_codebuild_project.central_tf_batch.arn
    }]
  })
}

resource "aws_iam_role" "codebuild_batch_execution" {
  name = "codebuild-central-batch-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "codebuild.amazonaws.com" }
    }]
  })
}

resource "aws_iam_policy" "batch_permissions" {
  name = "codebuild-batch-permissions-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowGridOrchestration"
        Effect   = "Allow"
        Action   = ["codebuild:StartBuild", "codebuild:StopBuild", "codebuild:RetryBuild", "codebuild:BatchGetBuilds"]
        Resource = "*"
      },
      {
        Sid      = "LoggingPermissions"
        Effect   = "Allow"
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Sid      = "SafeReadSafetyGuardrails"
        Effect   = "Allow"
        Action   = [
          "ssm:GetParameter", "ssm:GetParameters", "ssm:PutParameter",
          "s3:GetObject", "s3:ListBucket", "ec2:Describe*", "rds:Describe*", "eks:Describe*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "batch_attach" {
  role       = aws_iam_role.codebuild_batch_execution.name
  policy_arn = aws_iam_policy.batch_permissions.arn
}
