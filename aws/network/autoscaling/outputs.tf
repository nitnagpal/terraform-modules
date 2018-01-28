# Launch configuration
output "launch_configuration_id" {
  description = "The ID of the launch configuration"
  value       = "${var.launch_configuration == "" && var.create_launch_config ? element(concat(aws_launch_configuration.this.*.id, list("")), 0) : var.launch_configuration}"
}

output "launch_configuration_name" {
  description = "The name of the launch configuration"
  value       = "${var.launch_configuration == "" && var.create_launch_config ? element(concat(aws_launch_configuration.this.*.name, list("")), 0) : var.launch_configuration}"
}

# Autoscaling group
output "autoscaling_group_id" {
  description = "The autoscaling group id"
  value       = "${element(concat(aws_autoscaling_group.this.*.id, list("")), 0)}"
}

output "autoscaling_group_name" {
  description = "The autoscaling group name"
  value       = "${element(concat(aws_autoscaling_group.this.*.name, list("")), 0)}"
}

output "autoscaling_group_arn" {
  description = "The ARN for this AutoScaling Group"
  value       = "${element(concat(aws_autoscaling_group.this.*.arn, list("")), 0)}"
}

# ELB
output "elb_id" {
  description = "The ID of the ELB"
  value       = "${aws_elb.this.id}"
}

output "elb_name" {
  description = "The name of the ELB"
  value       = "${aws_elb.this.name}"
}

output "elb_dns_name" {
  description = "The DNS name of the ELB"
  value       = "${aws_elb.this.dns_name}"
}