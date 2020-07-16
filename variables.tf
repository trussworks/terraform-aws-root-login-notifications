variable "alarm_suffix" {
  type        = string
  default     = ""
  description = "Suffix to add to alarm name, used for separating different AWS account."
}

variable "sns_topic_name" {
  type        = string
  description = "The name of the SNS topic to send root login notifications."
}

variable "send_sns" {
  type        = bool
  default     = false
  description = "If true will send message *Successful AWS console login with the root account* to SNS topic"
}
