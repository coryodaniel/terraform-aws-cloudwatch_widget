// Metric
namespace   = "AWS/EC2"
metric_name = "CPUUtilization"

dimensions = [
  "InstanceId, i-012345",
  "InstanceId, i-678901"
]

// Properties
region = "us-west-2"
period = 300
stat = "Average"
title = "test"

// Widget
width = 6
height = 6
