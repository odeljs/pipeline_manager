locals {
  raw_pipelines_json = jsondecode(file("${path.module}/pipelines.json"))
}

resource "aws_cloudwatch_event_rule" "cron_drift_detection" {
  name        = "tfplan-cron-drift-detection"
  description = "Triggers the TF plan on a schedule to detect drift"
  
  schedule_expression = "rate(5 minutes)"#cron for once a day"cron(0 0 * * ? *)"
}

resource "aws_cloudwatch_event_target" "codepipeline_target" {
  for_each  = { for pipeline in local.raw_pipelines_json : pipeline.name => pipeline }
  rule      = aws_cloudwatch_event_rule.cron_drift_detection.name
  target_id = "TriggerCodePipeline-${each.key}"
  arn       = aws_codepipeline.codepipeline.arn
  role_arn  = aws_iam_role.eventbridge_to_pipeline_role.arn
  input = jsonencode({
    variables = [
      {
        name  = "REPO_PATH"
        value = each.value.repo_path
      },
      {
        name  = "OUTPUT_BUCKET_KEY"
        value = each.value.output_bucket_key # Or any static/dynamic value you need
      }
    ]
  })
}