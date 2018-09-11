// resource "aws_cloudwatch_metric_alarm" "this" {
//   count = "${length(var.resources)}"
//   actions_enabled     = "${var.actions_enabled}"
//   alarm_name          = "${var.name_prefix}-${var.metric_name}-${element(var.resources, count.index)}"
//   alarm_description   = "${var.description}"
//   comparison_operator = "${var.comparison_operator}"
//   evaluation_periods  = "${var.evaluation_periods}"
//   metric_name         = "${var.metric_name}"
//   namespace           = "${var.namespace}"
//   period              = "${var.period}"
//   statistic           = "${var.statistic}"
//   threshold           = "${var.threshold}"
//   alarm_actions       = ["${var.alarm_actions}"]
//   #dimensions          = "${map("${var.dimension}", "${element(var.resources, count.index)}")}"
//
//
//   dimensions {
//     ClientId = "048300154415"
//     DomainName = "prod-ops-k8s"
//   }
//
//   dimensions {
//     ClientId = "048300154415"
//     DomainName = "prod-ops-nope"
//   }
//
//   // dimensions { InstanceId = "${element(list("i-07656896d6947814c", "i-042e664331a74e385"), count.index)}" }
//   // dimensions { InstanceId = "${element(aws_instance.my_instance.*.id, count.index)}" }
//   // [ "AWS/ES", "FreeStorageSpace", "DomainName", "prod-ops-k8s", "ClientId", "048300154415" ]
// }

locals {
  first_key = "${element(keys(var.dimensions), 0)}"
}

data "template_file" "metric" {
  count = "${length(var.dimensions[local.first_key])}"
  template = <<JSON
[
   "${var.namespace}",
   "${var.metric_name}",
   "$${dims}"
]
JSON

  vars {
    dims = "${count.index}"
    // id = "${element(var.dimensions,count.index)}"
    #dimensions = "${zipmap(keys(var.dimensions[count.index]), values(var.dimensions[count.index]))}"
  }
}

data "template_file" "metrics" {
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
   "metrics":${data.template_file.metrics.rendered},
   "period":${var.period},
   "stat":"${var.statistic}",
   "region":"${var.region == false ? data.aws_region.current.name : var.region}",
   "title":"${var.description}"
}
JSON
}

resource "null_resource" "export_rendered_template0" {
  provisioner "local-exec" {
    command = "cat > /tmp/terraform-output.json <<EOL\n${data.template_file.metrics.rendered}\nEOL"
  }
}
