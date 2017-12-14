output "properties_json" {
  value = "${data.template_file.properties.rendered}"
}

output "metrics_json" {
  value = "${data.template_file.metric-wrapper.rendered}"
}

# output "ids" {
#
# }

# output "arns" {
#   # will need to map through an output
#   value = "arn:aws:cloudwatch:${data.aws_region.current}:${data.aws_caller_identity.current.account_id}:alarm:${aws_cloudwatch_metric_alarm.rds-database_cpu.id}"
# }
