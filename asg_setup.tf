resource "aws_launch_template" "web_launch_template" {
  name_prefix   = "web-server-launch-template"
  image_id      = "ami-03893e668ac36fad3"  # Nginx pre-installed AMI
  instance_type = "t2.micro"
  key_name      = aws_key_pair.asg_key.key_name
  
  vpc_security_group_ids = [aws_security_group.private_instance_sg.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Web Server"
    }
  }
}

resource "aws_autoscaling_group" "web_asg" {
  desired_capacity     = 2
  max_size             = 4
  min_size             = 2
  vpc_zone_identifier  = aws_subnet.private[*].id
  launch_template {
    id      = aws_launch_template.web_launch_template.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.app_tg.arn]

  tag {
    key                 = "Name"
    value               = "Web ASG Instance"
    propagate_at_launch = true
  }
}

data "aws_availability_zones" "available" {}
