variable "sns_topic_name" {
  type        = "string"
  description = "The name of the SNS topic to send root login notifications."
}

variable "enforce_sns_policy" {
  type = bool
  default = false
  description = "If enabled will enforce the SNS topic access policy to ensure events are allowed to be published."
}
