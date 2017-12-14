data "aws_caller_identity" "current" {}
data "aws_region" "current" {
  current = true
}

variable "actions_enabled" {
  default = true
}
variable "name_prefix" {}
variable "namespace" {}
variable "metric_name" {}
variable "description" {}
variable "comparison_operator" {}
variable "evaluation_periods" {}
variable "period" {}
variable "statistic" {}
variable "threshold" {}

variable "resources" {
  type = "list"
}

variable  "dimension" {
  default = "DBInstanceIdentifier"
}

variable  "insufficient_data_actions" {
  type = "list"
  default = []
}

variable  "ok_actions" {
  type = "list"
  default = []
}

variable  "alarm_actions" {
  type = "list"
  default = []
}
