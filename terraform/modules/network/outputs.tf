output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [for s in aws_subnet.eks_public_subnet : s.id]
}