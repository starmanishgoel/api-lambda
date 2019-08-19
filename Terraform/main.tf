provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "default"
  region                  = "${var.aws_region}"
}

data "aws_caller_identity" "current" { }

# Role for Lambda
resource "aws_iam_role" "iam_role_for_lambda" {
  name = "iam_role_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_logging" {
  name = "lambda_logging"
  path = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role = "${aws_iam_role.iam_role_for_lambda.name}"
  policy_arn = "${aws_iam_policy.lambda_logging.arn}"
}

# Lambda function for functions(Fibonacci, Factorial and Ackermann)
module "lambda_fib" {
  source  = "./lambda"
  name    = "Fibonacci"
  runtime = "python2.7"
  role    = "${aws_iam_role.iam_role_for_lambda.arn}"
}

module "lambda_fac" {
  source  = "./lambda"
  name    = "Factorial"
  runtime = "python2.7"
  role    = "${aws_iam_role.iam_role_for_lambda.arn}"
}

module "lambda_ackmn" {
  source  = "./lambda"
  name    = "Ackermann"
  runtime = "python2.7"
  role    = "${aws_iam_role.iam_role_for_lambda.arn}"
}

#API to expose functions publicly
resource "aws_api_gateway_rest_api" "mathf_api" {
  name = "Mathfunction API"
}

# The endpoint created here is: /fib
resource "aws_api_gateway_resource" "mathf_api_res_fib" {
  rest_api_id = "${aws_api_gateway_rest_api.mathf_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.mathf_api.root_resource_id}"
  path_part   = "fib"
}


# The endpoint created here is: /fac
resource "aws_api_gateway_resource" "mathf_api_res_fac" {
  rest_api_id = "${aws_api_gateway_rest_api.mathf_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.mathf_api.root_resource_id}"
  path_part   = "fac"
}

# The endpoint created here is: /ackmn
resource "aws_api_gateway_resource" "mathf_api_res_ackmn" {
  rest_api_id = "${aws_api_gateway_rest_api.mathf_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.mathf_api.root_resource_id}"
  path_part   = "ackmn"
}

#Validator to validate query parameters
resource "aws_api_gateway_request_validator" "request_validator" {
  name = "Validate query string parameters"
  rest_api_id = "${aws_api_gateway_rest_api.mathf_api.id}"
  validate_request_body = false
  validate_request_parameters = true
}

# GET method for /fib
module "get_fib" {
  source      = "./api_method"
  rest_api_id = "${aws_api_gateway_rest_api.mathf_api.id}"
  resource_id = "${aws_api_gateway_resource.mathf_api_res_fib.id}"
  method      = "GET"
  path        = "${aws_api_gateway_resource.mathf_api_res_fib.path}"
  lambda      = "${module.lambda_fib.name}"
  region      = "${var.aws_region}"
  account_id  = "${data.aws_caller_identity.current.account_id}"
  map_temp_json = "${file("singleparam.template")}"
  validate_param = "${var.req_single_param}"
  validate_id = "${aws_api_gateway_request_validator.request_validator.id}"
}

# GET method for /fac
module "get_fac" {
  source      = "./api_method"
  rest_api_id = "${aws_api_gateway_rest_api.mathf_api.id}"
  resource_id = "${aws_api_gateway_resource.mathf_api_res_fac.id}"
  method      = "GET"
  path        = "${aws_api_gateway_resource.mathf_api_res_fac.path}"
  lambda      = "${module.lambda_fac.name}"
  region      = "${var.aws_region}"
  account_id  = "${data.aws_caller_identity.current.account_id}"
  map_temp_json = "${file("singleparam.template")}"
  validate_param = "${var.req_single_param}"
  validate_id = "${aws_api_gateway_request_validator.request_validator.id}"

}

# GET method for /ackmn
module "get_ackmn" {
  source      = "./api_method"
  rest_api_id = "${aws_api_gateway_rest_api.mathf_api.id}"
  resource_id = "${aws_api_gateway_resource.mathf_api_res_ackmn.id}"
  method      = "GET"
  path        = "${aws_api_gateway_resource.mathf_api_res_ackmn.path}"
  lambda      = "${module.lambda_ackmn.name}"
  region      = "${var.aws_region}"
  account_id  = "${data.aws_caller_identity.current.account_id}"
  map_temp_json = "${file("doubleparam.template")}"
  validate_param = "${var.req_double_param}"
  validate_id = "${aws_api_gateway_request_validator.request_validator.id}"

}

# deploy the API to make it publicly available
resource "aws_api_gateway_deployment" "hello_api_deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.mathf_api.id}"
  stage_name  = "test"
  description = "Deploy methods: ${module.get_fib.http_method} ${module.get_fac.http_method} ${module.get_ackmn.http_method}"
}
