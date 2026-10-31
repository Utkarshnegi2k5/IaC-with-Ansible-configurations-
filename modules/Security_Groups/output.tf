output "control_sg_id" {
  value = aws_security_group.Control_sg.id
}

output "web_sg_id" {
  value = aws_security_group.Web_sg.id
}

output "db_sg_id" {
  value = aws_security_group.Db_sg.id
}

output "monitor_sg_id" {
  value = aws_security_group.Monitor_sg.id
}