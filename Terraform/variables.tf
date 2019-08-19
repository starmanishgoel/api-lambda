variable "aws_region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "req_single_param" {
  type = "map"

  default = {
    "method.request.header.Content-Type" = false,
    "method.request.querystring.n" = true
  }
}

variable "req_double_param" {
  type = "map"

  default = {
    "method.request.header.Content-Type" = false,
    "method.request.querystring.n" = true,
    "method.request.querystring.m" = true
  }
}


