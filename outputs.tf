output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
  description = "Public IP address of the bastion host."
}

output "alb_dns_name" {
  value       = aws_lb.app_lb.dns_name
  description = "DNS name of the Application Load Balancer."
}

output "Greetings" {
  value       = "Hello Sharanya!"
  description = "Greeting message."
}

output "asg_instance_key_name" {
  value       = aws_key_pair.asg_key.key_name
  description = "The key pair associated with the ASG instances."
}

data "aws_instances" "asg_instances" {
  filter {
    name   = "tag:Name"
    values = ["Web ASG Instance"]
  }
}

output "asg_private_ips" {
  value = data.aws_instances.asg_instances.private_ips
  description = "Private IP addresses of ASG instances."
  depends_on  = [aws_autoscaling_group.web_asg]
}


