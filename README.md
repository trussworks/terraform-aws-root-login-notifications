<!-- BEGIN_TF_DOCS -->
Enables notifications to an SNS topic when someone successfully logs in using the root account via the AWS Console in commercial AWS or using the Administrator user in AWS GovCloud.

Creates the following resources:

* CloudWatch event rule to filter for console logins with the root account or Administrator user.
* CloudWatch metric to trigger CW event when console rule is triggered
* CloudWatch event target to send notifications to an SNS topic (optional)

## Usage

```hcl

module "root-login-notifications" {
  source  = "trussworks/root-login-notifications/aws"
  version = "2.2.0"

  sns_topic_name = "slack-events"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.main_com](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_rule.main_gov](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_metric_alarm.alarm_cwe_triggered](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_sns_topic.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/sns_topic) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_suffix"></a> [alarm\_suffix](#input\_alarm\_suffix) | Suffix to add to alarm name, used for separating different AWS account. | `string` | `""` | no |
| <a name="input_send_sns"></a> [send\_sns](#input\_send\_sns) | If true will send message *Successful AWS console login with the root account* to SNS topic | `bool` | `false` | no |
| <a name="input_sns_topic_name"></a> [sns\_topic\_name](#input\_sns\_topic\_name) | The name of the SNS topic to send root login notifications. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->



## PagerDuty Setup

There are two methods to generate root logins alerts in PagerDuty.

### Method 1: CloudWatch Rule

Use this method if already have a SNS topic handling existing CW Events.

1. In TF or manually create a PagerDuty CloudWatch [integration](https://support.pagerduty.com/docs/aws-cloudwatch-integration-guide#section-integrating-with-a-pager-duty-service)
1. In TF ensure that the PagerDuty endpoint provided is assigned/subscribed to the SNS topic. For more info see the AWS topic about the proper [policy](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/CWE_Troubleshooting.html#RuleTriggeredMoreThanOnce).
1. Apply this module to the SNS topic.
1. Test by logging in as root



### Method 2: Custom PagerDuty Event

Use this method if wishing to have a dedicated SNS topic for PagerDuty alerts or custom message parsing for advanced PagerDuty features.

1. In TF or manually create a PagerDuty [Custom Event Transformer](https://v2.developer.pagerduty.com/docs/cet) CloudWatch
1. In TF ensure that the PagerDuty endpoint provided is assigned/subscribed to the SNS topic. For more info see the AWS topic about the proper [policy](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/CWE_Troubleshooting.html#RuleTriggeredMoreThanOnce).
1. Apply this module to the SNS topic with the `send_sns = true` and customizing the [input_template](https://github.com/trussworks/terraform-aws-root-login-notifications/blob/master/main.tf#L46) as needed.
1. Test by logging in as root

