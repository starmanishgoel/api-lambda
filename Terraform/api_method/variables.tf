variable "rest_api_id" {
  description = "The ID of the associated REST API"
}

variable "resource_id" {
  description = "The API resource ID"
}

variable "method" {
  description = "The HTTP method"
  default     = "GET"
}

variable "path" {
  description = "The API resource path"
}

variable "lambda" {
  description = "The lambda name to invoke"
}

variable "region" {
  description = "The AWS region, e.g., eu-west-1"
}

variable "account_id" {
  description = "The AWS account ID"
}

variable "map_temp_json" {
  description = "json for mapping values from API"
}

variable "validate_param" {
	type = "map"
  description = "json to validate required field"
}

variable "validate_id" {
  description = "Request validator for validating param"
}

