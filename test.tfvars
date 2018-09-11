// region = "us-west-2"
// name_prefix = "test"
// description = "test"
// namespace   = "AWS/ES"
// metric_name = "FreeStorageSpace"
// dimension   = "DomainName"
//
// comparison_operator = "LessThanThreshold"
// threshold           = "100000"
// statistic           = "Minimum"
// evaluation_periods  = "1"
// period              = "60"
// alarm_actions       = []
//
// resources = ["prod-ops-k8s"]

namespace   = "AWS/ES"
metric_name = "FreeStorageSpace"
region = "us-west-2"
period = 300
statistic = "Average"
description = "test"

// dimensions = {
//   ClientID = ["048300154415"]
//   DomainName = ["prod-ops-nope"]
// }

dimensions = {
  ClientID = ["048300154415", "048300154415"]
  DomainName = ["prod-ops-k8s", "prod-ops-nope"]
}

// dimensions = [
//   {
//     ClientId = "048300154415"
//     DomainName = "prod-ops-k8s"
//   },
//   {
//     ClientId = "048300154415"
//     DomainName = "prod-ops-nope"
//   }
// ]
