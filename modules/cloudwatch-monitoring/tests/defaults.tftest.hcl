mock_provider "aws" {}

run "creates_no_alarms_without_explicit_configuration" {
  command = plan
  variables {
    project     = "platform"
    environment = "test"
  }
  assert {
    condition     = length(var.alarms) == 0
    error_message = "No thresholds or destinations should be invented by the module."
  }
}

run "rejects_unsupported_comparison_operator" {
  command = plan
  variables {
    project     = "platform"
    environment = "test"
    alarms = {
      invalid = {
        alarm_description   = "Invalid alarm"
        namespace           = "AWS/EC2"
        metric_name         = "CPUUtilization"
        statistic           = "Average"
        period              = 60
        evaluation_periods  = 1
        threshold           = 80
        comparison_operator = "EqualToThreshold"
        dimensions          = { InstanceId = "i-12345678" }
      }
    }
  }
  expect_failures = [var.alarms]
}
