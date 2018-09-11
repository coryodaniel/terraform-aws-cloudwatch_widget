# terraform-aws-cloudwatch_widget

Render AWS Cloudwatch widgets JSON from Terraform

## Usage

This module can render three types of JSON output for [AWS Cloudwatch Dashboard](https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/CloudWatch-Dashboard-Body-Structure.html).

* metrics - (`module.NAME.metrics_json`) Only the namespace, metric an dimensions. This will allow you to customize the properties and widget JSON in your code.
* properties - (`module.NAME.properties_json`) _metrics_json_ plus UI properties (stack, period, statistic, etc)
* widget - (`module.NAME.widget_json`) _metrics_ and _properties_ plus height and width of the widget for placement in the dashboard

No matter which set of variables you provide, you always get all three JSON output types in the terraform output. You can use whichever you need:

```
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

metrics_json = [["AWS/EC2","CPUUtilization","InstanceId","i-012345"], ["AWS/EC2","CPUUtilization","InstanceId","i-678901"]]

properties_json = {
   "metrics":[["AWS/EC2","CPUUtilization","InstanceId","i-012345"], ["AWS/EC2","CPUUtilization","InstanceId","i-678901"]],
   "period":300,
   "region":"us-west-2",
   "stacked":false,
   "stat":"Average",
   "title":"test",
   "view":"timeSeries"
}

widget_json = {
  "width": "6",
  "height": "6",
  "properties": {
    "metrics":[["AWS/EC2","CPUUtilization","InstanceId","i-012345"], ["AWS/EC2","CPUUtilization","InstanceId","i-678901"]],
    "period":300,
    "region":"us-west-2",
    "stacked":false,
    "stat":"Average",
    "title":"test",
    "view":"timeSeries"
  }
}
```

### Usage with [`aws_cloudwatch_dashboard`](https://www.terraform.io/docs/providers/aws/r/cloudwatch_dashboard.html)

In this example I am going to use the same widget three times, once with each output type to demonstrate:

_First create the widget_:

```hcl
module "cpu_utilization" {
  source = "github.com/coryodaniel/terraform-aws-cloudwatch_widget"

  // Metrics
  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"

  // A comma separated list of DimensionNames and DimensionsValues.
  // Due to a limitation in Terraform, nested lists can't currently be passed through modules.
  dimensions = [
    "InstanceId, i-012345",
    "InstanceId, i-678901"
  ]

  // Properties - OPTIONAL
  region = "us-west-2"
  period = 300
  stat = "Average"
  title = "test"

  // Widget - OPTIONAL
  width = 6
  height = 6
}
```

_Now use it in a dashboard_:

```hcl
resource "aws_cloudwatch_dashboard" "dashboard" {
   dashboard_name = "My Dashboard!"
   dashboard_body = <<EOF
{
  "widgets": [
    // This renders the full widget JSON
    ${module.cpu_utilization.widget_json},

    // This will render the properties JSON
    {
       "type":"metric",
       "width":12,
       "height":6,
       "properties":${module.cpu_utilization.properties_json}
    },

    // This will only render the metrics JSON
    {
       "type":"metric",
       "width":12,
       "height":6,
       "properties": {
         "period": 300,
         "region": "us-west-2",
         "stacked": false,
         "stat": "Average",
         "title": "test",
         "view": "timeSeries",
         "metrics": ${module.cpu_utilization.metrics_json}
       }
    }
  ]
EOF
}
```
