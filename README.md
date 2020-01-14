Enables notifications to an SNS topic when someone successfully logs in using the root account via the AWS Console.

Creates the following resources:

* CloudWatch event rule to filter for console logins with the root account.
* CloudWatch event target to send notifications to an SNS topic.

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
| sns\_topic\_name | The name of the SNS topic to send root login notifications. | string | n/a | yes |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
