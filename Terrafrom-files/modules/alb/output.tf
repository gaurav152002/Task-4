
# ===== ALB DNS name =====
output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.alb.dns_name
}

# ===== ALB Security Group ID =====
output "alb_sg_id" {
  description = "Security group ID of ALB"
  value       = aws_security_group.alb_sg.id
}
