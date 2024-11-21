output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main_vpc.id
}

output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.main_alb.dns_name
}

output "autoscaling_group_name" {
  description = "The name of the Auto Scaling Group"
  value       = aws_autoscaling_group.sample_asg.name
}

output "greetings" {
  description = "Hi"
  value       = "Hi Sharanya"
}

# Output for Bastion Host Public IP
output "bastion_public_ip" {
  description = "The public IP address of the Bastion Host"
  value       = aws_eip.nat_eip.public_ip
}