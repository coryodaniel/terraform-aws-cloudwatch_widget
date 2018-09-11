output "metrics_json" {
  value = "${data.template_file.metrics.rendered}"
}

output "properties_json" {
  value = "${data.template_file.properties.rendered}"
}

output "widget_json" {
  value = "${data.template_file.widget.rendered}"
}
