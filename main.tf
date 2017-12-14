resource "aws_cloudwatch_metric_alarm" "this" {
  count = "${length(var.resources)}"
  actions_enabled     = "${var.actions_enabled}"
  alarm_name          = "${var.name_prefix}-${basename(var.namespace)}-${var.metric_name}-${element(var.resources, count.index)}"
  alarm_description   = "${var.description}"
  comparison_operator = "${var.comparison_operator}"
  evaluation_periods  = "${var.evaluation_periods}"
  metric_name         = "${var.metric_name}"
  namespace           = "${var.namespace}"
  period              = "${var.period}"
  statistic           = "${var.statistic}"
  threshold           = "${var.threshold}"
  alarm_actions       = ["${var.alarm_actions}"]
  dimensions          = "${map("${var.dimension}", "${element(var.resources, count.index)}")}"
}

data "template_file" "metric" {
  count = "${length(var.resources)}"
  template = <<JSON
[
   "${var.namespace}",
   "${var.metric_name}",
   "${var.dimension}",
   "$${id}"
]
JSON

  vars {
    id = "${element(var.resources,count.index)}"
  }
}

data "template_file" "metric-wrapper" {
  template = <<JSON
[
  $${list_of_metrics}
]
JSON
  vars {
    list_of_metrics = "${join(",\n", data.template_file.metric.*.rendered)}"
  }
}

data "template_file" "properties" {
  template = <<JSON
{
   "metrics":${data.template_file.metric-wrapper.rendered},
   "period":${var.period},
   "stat":"${var.statistic}",
   "region":"${data.aws_region.current.name}",
   "title":"${var.description}"
}
JSON
}

# resource "null_resource" "export_rendered_template0" {
#   provisioner "local-exec" {
#     command = "cat > /tmp/terraform-output.json <<EOL\n${data.template_file.cpu_utilization-wrapper.rendered}\nEOL"
#   }
# }
