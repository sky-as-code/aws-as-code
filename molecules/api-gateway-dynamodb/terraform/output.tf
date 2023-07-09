output "api_root_url" {
  value       = "${aws_api_gateway_deployment.restapi.invoke_url}${aws_api_gateway_stage.reststage.stage_name}"
  description = "Root URL of the API Gateway"
}

output "aws_region" {
  value       = local.aws_region
  description = "AWS Region for debugging"
}