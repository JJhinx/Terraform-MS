#data "aws_subnet_ids" "vpc_ms_subnets" {
#    vpc_id = data.aws_vpc.vpc_ms.id
#}

#autoscaler
resource "aws_autoscaling_group" "ASG-MS" {
    launch_template {
        id = aws_launch_template.webserver-LT-MS.id
    }

    min_size = 2
    max_size = 4
    desired_capacity = 2

    health_check_type = "EC2"
    target_group_arns = [aws_lb_target_group.LoadBalancerTargetGroup.arn]
    #availability_zones = [ "eu-west-1a", "eu-west-1b", "eu-west-1c" ]
    vpc_zone_identifier = [aws_subnet.Subnet-1-MS.id, aws_subnet.Subnet-2-MS.id]

    tag {
        key = "name"
        value = "ASC-Webserver-MS"
        propagate_at_launch = true
    }
}

#----------------------------------------------------------------
#autoscaling policies
resource "aws_autoscaling_policy" "upscaling_policy" {
    name = "scale up"
    scaling_adjustment = 1
    adjustment_type = "ChangeInCapacity"
    cooldown = 60
    autoscaling_group_name = aws_autoscaling_group.ASG-MS.name
}

resource "aws_autoscaling_policy" "downscaling_policy" {
    name = "scale down"
    scaling_adjustment = -1
    adjustment_type = "ChangeInCapacity"
    cooldown = 60
    autoscaling_group_name = aws_autoscaling_group.ASG-MS.name
}