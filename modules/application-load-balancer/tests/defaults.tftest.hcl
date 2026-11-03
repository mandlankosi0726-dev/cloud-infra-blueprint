mock_provider "aws" {}

run "requires_https_and_deletion_protection" {
  command = plan
  variables {
    name               = "web-alb"
    project            = "platform"
    environment        = "test"
    subnet_ids         = ["subnet-11111111", "subnet-22222222"]
    vpc_id             = "vpc-12345678"
    security_group_ids = ["sg-12345678"]
    target_port        = 8080
    certificate_arn    = "arn:aws:acm:us-east-1:111122223333:certificate/example"
  }

  assert {
    condition     = aws_lb.this.internal && aws_lb.this.enable_deletion_protection
    error_message = "The load balancer should default to internal with deletion protection."
  }
  assert {
    condition     = aws_lb_listener.https.protocol == "HTTPS" && aws_lb_listener.https.port == 443
    error_message = "The forwarding listener must use HTTPS on port 443."
  }
}

run "rejects_empty_certificate" {
  command = plan
  variables {
    name               = "web-alb"
    project            = "platform"
    environment        = "test"
    subnet_ids         = ["subnet-11111111", "subnet-22222222"]
    vpc_id             = "vpc-12345678"
    security_group_ids = ["sg-12345678"]
    target_port        = 8080
    certificate_arn    = ""
  }
  expect_failures = [var.certificate_arn]
}
