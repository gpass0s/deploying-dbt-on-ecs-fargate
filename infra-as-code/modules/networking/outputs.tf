output "sg-id" {
  value       = aws_security_group.sg_for_ecs_cluster.id
  description = "Lambada security group id"
}
