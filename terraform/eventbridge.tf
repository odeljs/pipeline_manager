resource "aws_cloudwatch_event_rule" "cron_drift_detection" {
  name        = "tfplan-cron-drift-detection"
  description = "Triggers the TF plan on a schedule to detect drift"
  
  schedule_expression = "cron(0 0 * * ? *)"
}

resource "aws_cloudwatch_event_target" "codepipeline_target" {
  rule      = aws_cloudwatch_event_rule.cron_drift_detection.name
  target_id = "TriggerCodePipeline"
  arn       = aws_codepipeline.terraform_pipeline.arn
  role_arn  = aws_iam_role.eventbridge_to_pipeline_role.arn
  input = jsonencode({
    variables = [
      {
        name  = "OUTPUT_BUCKET_KEY"
        value = "/path/to/my-file.zip"
      }
    ]
  })
}