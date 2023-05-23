output "api_root_url" {
  value       = "${aws_api_gateway_deployment.restapi.invoke_url}${aws_api_gateway_stage.reststage.stage_name}"
  description = "Root URL of the API Gateway"
}

output "api_client_id" {
  value = aws_cognito_user_pool_client.client.id
}

output "auth_url" {
  value       = "https://${aws_cognito_user_pool.all_users.domain}.auth.${local.aws_region}.amazoncognito.com/login"
  description = "URL to get access token"
}

output "aws_region" {
  value       = local.aws_region
  description = "AWS Region for debugging"
}