# https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/CloudWatch-Dashboard-Body-Structure.html#CloudWatch-Dashboard-Properties-Metric-Widget-Object

variable "dimensions" {
  description = "A comma separated list of DimensionNames and DimensionsValues. Due to a limitation in Terraform, nested lists can't be passed through modules. :("
  type = "list"
  default = []
}

variable "metric_name" {}

variable "namespace" {}

// Widget Properties

variable "height" {
  default = 6
}

variable "width" {
  default = 6
}

// Metric Object Properties

variable "region" {
  default = "us-east-1"
}

variable "period" {
  default = 300
}

variable "stacked" {
  default = false
}

variable "stat" {
  default = "Average"
}

variable "title" {
  default = false
}

variable "view" {
  default = "timeSeries"
}
