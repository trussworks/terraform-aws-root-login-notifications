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
| send\_sns | If true will send message *Successful AWS console login with the root account* to SNS topic | bool | `"false"` | no |
| sns\_topic\_name | The name of the SNS topic to send root login notifications. | string | n/a | yes |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
