resource "aws_ssm_parameter" "app_config" {
  name        = "/pipeline_manager/pipelines_parameters/pipelines"
  description = "pipeline data for all application IaC"
  type        = "String" 
  value       = file("${path.module}/pipelines.json")
}