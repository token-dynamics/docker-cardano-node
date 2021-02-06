output "instance_id" {
  value = aws_instance.relay.id
}

output "public_ip" {
  value = aws_instance.relay.public_ip
} 

output "eip" {
  value = aws_eip.relay.public_ip
}