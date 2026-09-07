resource "aws_cloudwatch_event_bus" "tf_modules" {
  name = "terraform-module-updates"
}

resource "aws_cloudwatch_event_rule" "trigger_batch" {
  name           = "trigger-central-terraform-batch-tester"
  description    = "Catches cross-repo module updates and kicks off parallel batch plans"
  event_bus_name = aws_cloudwatch_event_bus.tf_modules.name

  event_pattern = jsonencode({
    source      = ["custom.terraform.modules"]
    detail-type = ["Module Version Updated"]
  })
}

resource "aws_cloudwatch_event_target" "batch_target" {
  rule           = aws_cloudwatch_event_rule.trigger_batch.name
  event_bus_name = aws_cloudwatch_event_bus.tf_modules.name
  arn            = aws_codebuild_project.central_tf_batch.arn
  role_arn       = aws_iam_role.eventbridge_to_codebuild.arn
}