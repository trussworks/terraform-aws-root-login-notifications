/**
 * Enables notifications to an SNS topic when someone successfully logs in using the root account via the AWS Console in commercial AWS or using the Administrator user in AWS GovCloud.
 *
 * Creates the following resources:
 *
 * * CloudWatch event rule to filter for console logins with the root account or Administrator user.
 * * CloudWatch metric to trigger CW event when console rule is triggered
 * * CloudWatch event target to send notifications to an SNS topic.(optional)
 *
 * ## Usage
 *
 * ```hcl
 *
 * module "root-login-notifications" {
 *   source  = "trussworks/root-login-notifications/aws"
 *   version = "1.0.0"
 *
 *   sns_topic_name = "slack-events"
 * }
 * ```
 */

#
# SNS
#

data "aws_sns_topic" "main" {
  name = var.sns_topic_name
}

#
# CloudWatch Event
#

resource "aws_cloudwatch_event_rule" "main" {
  name          = "iam-root-login"
  description   = "Successful login with root account"
  event_pattern = var.govcloud_check ? file("${path.module}/govcloud-event-pattern.json") : file("${path.module}/event-pattern.json")
}

resource "aws_cloudwatch_event_target" "main" {
  count     = var.send_sns ? 1 : 0
  rule      = aws_cloudwatch_event_rule.main.name
  target_id = "send-to-sns"
  arn       = data.aws_sns_topic.main.arn

  input_transformer {
    input_template = "\"Successful AWS console login with the root account.\""
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm_cwe_triggered" {
  alarm_name          = var.alarm_suffix == "" ? "iam-root-login-alarm" : "iam-root-login-alarm-${var.alarm_suffix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  datapoints_to_alarm = "1"
  metric_name         = "TriggeredRules"
  namespace           = "AWS/Events"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "IAM Root Login CW Rule has been triggered"
  alarm_actions       = [data.aws_sns_topic.main.arn]
  ok_actions          = [data.aws_sns_topic.main.arn]

  dimensions = {
    RuleName = aws_cloudwatch_event_rule.main.name
  }
}

