#cloudwatch alarm for ASG
resource "aws_cloudwatch_metric_alarm" "high_CPU" {
    alarm_name = "high CPU warning"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = 1
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = 60
    statistic = "Average"
    threshold = 60
    alarm_actions = [aws_autoscaling_policy.upscaling_policy.arn]

    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.ASG-MS.name
    }
}

resource "aws_cloudwatch_metric_alarm" "Low_CPU" {
    alarm_name = "Low CPU warning"
    comparison_operator = "LessThanThreshold"
    evaluation_periods = 1
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = 360
    statistic = "Average"
    threshold = 20
    alarm_actions = [aws_autoscaling_policy.downscaling_policy.arn]

    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.ASG-MS.name
    }
}