output "aws_instance_public_dns" {
  description = "Our EC2 public ip"
  value       = aws_instance.ec2_instance.public_dns
}