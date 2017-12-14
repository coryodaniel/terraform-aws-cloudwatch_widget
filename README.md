# terraform-aws-cloudwatch_widget

Define a cloudwatch metric alarm, get its JSON to make a dashboard. Woot.
## Usage


```tf
module "cpu_utilization" {
  source = "github.com/coryodaniel/terraform-aws-cloudwatch_widget"
  name_prefix = "${terraform.workspace}"
  description = "Database server CPU utilization"
  namespace   = "AWS/RDS"
  metric_name = "CPUUtilization"
  dimension   = "DBInstanceIdentifier"

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  period              = "300"
  statistic           = "Average"
  threshold           = "75"
  alarm_actions       = ["${aws_sns_topic.rds-alarms.arn}"]

  resources = "${my_list_of_rds_ids}"
}

resource "aws_cloudwatch_dashboard" "rds-dashboard" {
   dashboard_name = "${terraform.workspace}-rds-metrics"
   dashboard_body = <<EOF
{
  "widgets": [
    {
       "type":"metric",
       "width":12,
       "height":6,
       "properties":${module.cpu_utilization.properties_json}
    },
    
    {
       "type":"metric",
       "width":12,
       "height":6,
       "properties": {
         "metrics": ${module.cpu_utilization.metrics_json},
         "stat":"Average",
         "region":"us-east-1",
         "title":"Metrics example, set your own properties."         
       }
    },
  ]
}
EOF
}
```
