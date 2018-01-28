## Launch Configuration ##
resource "aws_launch_configuration" "this" {
  count                       = "${var.create_launch_config}"
  name                        = "${var.env}-${var.name}-launch-config"
  image_id                    = "${var.image_id}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  key_name                    = "${var.key_name}"
  security_groups             = ["${var.security_groups}"]
  associate_public_ip_address = "${var.associate_public_ip_address}"
  user_data                   = "${var.user_data}"
  enable_monitoring           = "${var.enable_monitoring}"
  ebs_optimized               = "${var.ebs_optimized}"
  ebs_block_device            = "${var.ebs_block_device}"
  ephemeral_block_device      = "${var.ephemeral_block_device}"
  root_block_device           = "${var.root_block_device}"
  lifecycle {
    create_before_destroy = true
  }
}

## Auto Scaling Group ##
resource "aws_autoscaling_group" "this" {
  count                     = "${var.create_autoscaling_group}"
  name                      = "${var.env}-${var.name}-asg"
  max_size                  = "${var.max_size}"
  min_size                  = "${var.min_size}"
  default_cooldown          = "${var.default_cooldown}"
  launch_configuration      = "${var.create_autoscaling_group ? element(aws_launch_configuration.this.*.name, 0) : var.launch_configuration}"
  force_delete              = "${var.force_delete}"

  load_balancers            = ["${split(",", var.create_elb ? join(",", aws_elb.this.*.name) : join(",", var.load_balancers))}"]
  vpc_zone_identifier       = ["${var.vpc_zone_identifier}"]
  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type         = "${var.health_check_type}"
  desired_capacity          = "${var.desired_capacity}"
  min_elb_capacity          = "${var.min_elb_capacity}"
  wait_for_elb_capacity     = "${var.wait_for_elb_capacity}"

  termination_policies      = "${var.termination_policies}"
  suspended_processes       = "${var.suspended_processes}"
  placement_group           = "${var.placement_group}"
  metrics_granularity       = "${var.metrics_granularity}"
  enabled_metrics           = ["${var.enabled_metrics}"]
  wait_for_capacity_timeout = "${var.wait_for_capacity_timeout}"
  protect_from_scale_in     = "${var.protect_from_scale_in}"

  tags = ["${concat(
      list(map("key", "Name", "value", var.name, "propagate_at_launch", true)),
      var.asg_tags
   )}"]
}

## ELB ##
resource "aws_elb" "this" {
  count                       = "${var.create_elb}"
  name                        = "${var.env}-${var.name}-elb"
  internal                    = "${var.internal}"
  subnets                     = ["${var.subnets}"]
  security_groups             = ["${var.elb_security_groups}"]
  listener                    = ["${var.listener}"]
  access_logs                 = ["${var.access_logs}"]
  health_check                = ["${var.health_check}"]
  cross_zone_load_balancing   = "${var.cross_zone_load_balancing}"
  idle_timeout                = "${var.idle_timeout}"
  connection_draining         = "${var.connection_draining}"
  connection_draining_timeout = "${var.connection_draining_timeout}"
  tags                        = "${merge(var.elb_tags, map("Name", format("%s", var.name)))}"
}