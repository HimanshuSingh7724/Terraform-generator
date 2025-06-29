output "instance_id" {
  value = aws_instance.my_ec2.id
}

output "alarm_name" {
  value = aws_cloudwatch_metric_alarm.cpu_utilization_alarm.alarm_name
}
