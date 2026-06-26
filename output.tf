output "ec2_public_ip" {
    value = aws_instance.cv_first_ec2_instance.public_ip
  
}

output "database_endpoint" {
    value = aws_db_instance.cv_first_postgres.endpoint
  
}