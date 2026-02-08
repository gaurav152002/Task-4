##=== VPC output ===##
output "vpc_id" {
    value = aws_vpc.this.id 
}

##===== Subnet outputs =====##
output "public_subnet_id" {
    value = aws_subnet.public.id  
}
output "private_subnet_id" {
    value = aws_subnet.private.id
}

output "public_subnet_2_id" {
  value = aws_subnet.public_2.id
}

##===== Public subnet IDs list (for ALB) =====##
output "public_subnet_ids" {
  description = "List of public subnet IDs for ALB"
  value = [
    aws_subnet.public.id,
    aws_subnet.public_2.id
  ]
}
