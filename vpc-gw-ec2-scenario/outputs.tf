output "eip" {
  value = aws_eip.tf.public_ip
}

output "website_addr" {
  value = "https://${aws_route53_record.tf.name}"
}

