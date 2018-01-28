## Usage
```
module "autoscaling" {
  source           = "/path/to/terraform-modules/aws/network/autoscaling"
  env              = "${var.env}"
  name             = "terraform"
  create_elb       = true
  ## Launch Configuration ##
  image_id         = "ami-531a***"
  instance_type    = "t2.micro"
  security_groups  = ["sg-8721****"]
  ebs_block_device = [
    {
      device_name           = "/dev/xvdb"
      volume_type           = "gp2"
      volume_size           = "5"
      delete_on_termination = true
    }
  ]
  root_block_device = [
    {
      volume_size = "10"
      volume_type = "gp2"
    }
  ]

  ## Auto Scaling Group ##
  vpc_zone_identifier       = ["subnet-74a60***", "subnet-21332***"]
  health_check_type         = "ELB"
  min_size                  = 1
  max_size                  = 5
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  asg_tags = [
    {
      key                 = "Environment"
      value               = "${var.env}"
      propagate_at_launch = true
    },
    {
      key                 = "Terraform"
      value               = true
      propagate_at_launch = true
    },
  ]

  ## ELB ##
  subnets         = ["subnet-74a60***", "subnet-21332***"]
  elb_security_groups = ["sg-fc1de***"]
  listener = [
    {
      instance_port     = "80"
      instance_protocol = "HTTP"
      lb_port           = "80"
      lb_protocol       = "HTTP"
    }
  ]
  health_check = [
    {
      target              = "HTTP:80/"
      interval            = 30
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 5
    }
  ]
  access_logs = [
    {
      bucket = "my-logs-bucket"
    }
  ]
  elb_tags = {
    Terraform   = "true"
    Environment = "${var.env}"
  }
}

output "launch-configuration-id" {
  value = "${module.autoscaling.launch_configuration_id}"
}

output "launch-configuration-name" {
  value = "${module.autoscaling.launch_configuration_name}"
}

output "autoscaling-group-id" {
  value = "${module.autoscaling.autoscaling_group_id}"
}

output "autoscaling-group-name" {
  value = "${module.autoscaling.autoscaling_group_name}"
}

output "autoscaling-group-arn" {
  value = "${module.autoscaling.autoscaling_group_arn}"
}
```
## Output 
```
autoscaling-group-arn = arn:aws:autoscaling:ap-south-1:****2297****:autoScalingGroup:****8987-fecd-****-9c24-7d0ac046da4c:autoScalingGroupName/prod-terraform-asg
autoscaling-group-id = prod-terraform-asg
autoscaling-group-name = prod-terraform-asg
launch-configuration-id = prod-terraform-launch-config
launch-configuration-name = prod-terraform-launch-config
```
