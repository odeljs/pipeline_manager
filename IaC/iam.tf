#################CodePipeline Permissions#################
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "codepipeline_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject",
      "s3:GetBucketLocation",
      "s3:GetObjectTagging",
      "s3:GetObjectVersionTagging"
    ]

    resources = [
      aws_s3_bucket.teraform_plan_artifacts_bucket.arn,
      "${aws_s3_bucket.teraform_plan_artifacts_bucket.arn}/*",
      aws_s3_bucket.teraform_plan_input_bucket.arn,
      "${aws_s3_bucket.teraform_plan_input_bucket.arn}/*"
    ]
  }

  statement {
    effect    = "Allow"
    actions   = ["codestar-connections:UseConnection"]
    resources = [data.aws_codestarconnections_connection.code_connection.arn]
  }

  statement {
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "codepipeline_policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}

##########################################################

#################Eventbridge CodePipeline Permissions#################
data "aws_iam_policy_document" "assume_role_eventbridge" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eventbridge_to_pipeline_role" {
  name               = "eventbridge_pipeline_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_eventbridge.json
}

data "aws_iam_policy_document" "eventbridge_codepipeline_policy" {

  statement {
    effect = "Allow"

    actions = [
      "codepipeline:StartPipelineExecution"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "eventbridge_codepipeline_policy" {
  name   = "eventbridge_codepipeline_policy"
  role   = aws_iam_role.eventbridge_to_pipeline_role.id
  policy = data.aws_iam_policy_document.eventbridge_codepipeline_policy.json
}

######################################################################

#################CodeBuild Permissions#################

resource "aws_iam_role" "codebuild_admin_role" {
  name = "codebuild-admin-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "admin_attach" {
  role       = aws_iam_role.codebuild_admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}