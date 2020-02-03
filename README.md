Enables notifications to an SNS topic when someone successfully logs in using the root account via the AWS Console.

Creates the following resources:

* CloudWatch event rule to filter for console logins with the root account.
* CloudWatch metric to trigger CW event when console rule is triggered
* CloudWatch event target to send notifications to an SNS topic. (optional)

## Usage

```hcl

module "root-login-notifications" {
  source  = "trussworks/root-login-notifications/aws"
  version = "1.0.0"

  sns_topic_name = "slack-events"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alarm\_suffix | Suffix to add to alarm name, used for separating different AWS account. | string | `""` | no |
| send\_sns | If true will send message \*Successful AWS console login with the root account\* to SNS topic | bool | `"false"` | no |
| sns\_topic\_name | The name of the SNS topic to send root login notifications. | string | n/a | yes |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->



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

