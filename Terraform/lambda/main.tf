resource "aws_lambda_function" "lambda" {
  filename      = "${var.name}.zip"
  function_name = "${var.name}_${var.handler}"
  role          = "${var.role}"
  handler       = "${var.name}.${var.handler}"
  runtime       = "${var.runtime}"
}

resource "aws_cloudwatch_log_group" "mathf_cloudwatch" {
  name              = "/aws/lambda/${var.name}_${var.handler}"
  retention_in_days = 14
}


