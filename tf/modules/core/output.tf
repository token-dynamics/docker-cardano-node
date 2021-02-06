output "instance_id" {
  value = aws_instance.core.id
}

output "private_ip" {
  value = aws_instance.core.private_ip
}

output "public_ip" {
  value = aws_instance.core.public_ip
}