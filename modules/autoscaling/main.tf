/**
 * # EC2 Auto Scaling Group Module
 *
 * This module creates an Auto Scaling Group with configurable parameters
 * following AWS best practices for right-sizing and cost optimization.
 */

# Launch template for the Auto Scaling Group
resource "aws_launch_template" "this" {
  name_prefix   = "${var.name}-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  
  vpc_security_group_ids = var.security_group_ids
  
  iam_instance_profile {
    name = var.iam_instance_profile
  }
  
  user_data = var.user_data != null ? base64encode(var.user_data) : var.user_data_base64
  
  monitoring {
    enabled = var.enable_detailed_monitoring
  }
  
  block_device_mappings {
    device_name = "/dev/sda1"
    
    ebs {
      volume_size           = var.root_volume_size
      volume_type           = var.root_volume_type
      delete_on_termination = var.root_volume_delete_on_termination
      encrypted             = var.root_volume_encrypted
      kms_key_id            = var.root_volume_kms_key_id
    }
  }
  
  metadata_options {
    http_endpoint               = var.metadata_http_endpoint
    http_tokens                 = var.metadata_http_tokens
    http_put_response_hop_limit = var.metadata_http_put_response_hop_limit
  }
  
  # Right-sizing: Use instance types based on workload requirements
  dynamic "instance_market_options" {
    for_each = var.use_spot_instances ? [1] : []
    content {
      market_type = "spot"
      spot_options {
        max_price = var.spot_price
      }
    }
  }
  
  tag_specifications {
    resource_type = "instance"
    tags = merge(
      {
        Name = var.name
      },
      var.tags,
      var.cost_allocation_tags
    )
  }
  
  tag_specifications {
    resource_type = "volume"
    tags = merge(
      {
        Name = var.name
      },
      var.volume_tags,
      var.cost_allocation_tags
    )
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "this" {
  name_prefix               = "${var.name}-"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  force_delete              = var.force_delete
  termination_policies      = var.termination_policies
  suspended_processes       = var.suspended_processes
  vpc_zone_identifier       = var.subnet_ids
  target_group_arns         = var.target_group_arns
  default_cooldown          = var.default_cooldown
  
  # Right-sizing: Use mixed instances policy for cost optimization
  dynamic "mixed_instances_policy" {
    for_each = length(var.override_instance_types) > 0 ? [1] : []
    content {
      instances_distribution {
        on_demand_base_capacity                  = var.on_demand_base_capacity
        on_demand_percentage_above_base_capacity = var.on_demand_percentage_above_base_capacity
        spot_allocation_strategy                 = var.spot_allocation_strategy
        spot_instance_pools                      = var.spot_instance_pools
        spot_max_price                           = var.spot_price
      }
      
      launch_template {
        launch_template_specification {
          launch_template_id = aws_launch_template.this.id
          version            = aws_launch_template.this.latest_version
        }
        
        dynamic "override" {
          for_each = var.override_instance_types
          content {
            instance_type = override.value
          }
        }
      }
    }
  }
  
  # Use launch template directly if no mixed instances are specified
  dynamic "launch_template" {
    for_each = length(var.override_instance_types) == 0 ? [1] : []
    content {
      id      = aws_launch_template.this.id
      version = aws_launch_template.this.latest_version
    }
  }
  
  # Enable instance refresh for rolling updates
  dynamic "instance_refresh" {
    for_each = var.enable_instance_refresh ? [1] : []
    content {
      strategy = "Rolling"
      preferences {
        min_healthy_percentage = var.instance_refresh_min_healthy_percentage
        instance_warmup        = var.instance_refresh_warmup
      }
    }
  }
  
  # Tagging for cost tracking
  dynamic "tag" {
    for_each = merge(
      {
        Name = var.name
      },
      var.tags,
      var.cost_allocation_tags
    )
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }
}

# Auto Scaling Policies
resource "aws_autoscaling_policy" "scale_up" {
  count                  = var.enable_scaling_policies ? 1 : 0
  name                   = "${var.name}-scale-up"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = var.scale_up_adjustment
  cooldown               = var.scale_up_cooldown
}

resource "aws_autoscaling_policy" "scale_down" {
  count                  = var.enable_scaling_policies ? 1 : 0
  name                   = "${var.name}-scale-down"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = var.scale_down_adjustment
  cooldown               = var.scale_down_cooldown
}

# CloudWatch Alarms for Auto Scaling
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  count               = var.enable_scaling_policies ? 1 : 0
  alarm_name          = "${var.name}-high-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.high_cpu_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.high_cpu_period
  statistic           = "Average"
  threshold           = var.high_cpu_threshold
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }
  
  alarm_description = "Scale up if CPU utilization is above ${var.high_cpu_threshold} for ${var.high_cpu_evaluation_periods} periods of ${var.high_cpu_period} seconds"
  alarm_actions     = [aws_autoscaling_policy.scale_up[0].arn]
  
  tags = merge(
    var.tags,
    var.cost_allocation_tags
  )
}

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  count               = var.enable_scaling_policies ? 1 : 0
  alarm_name          = "${var.name}-low-cpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.low_cpu_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.low_cpu_period
  statistic           = "Average"
  threshold           = var.low_cpu_threshold
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }
  
  alarm_description = "Scale down if CPU utilization is below ${var.low_cpu_threshold} for ${var.low_cpu_evaluation_periods} periods of ${var.low_cpu_period} seconds"
  alarm_actions     = [aws_autoscaling_policy.scale_down[0].arn]
  
  tags = merge(
    var.tags,
    var.cost_allocation_tags
  )
}