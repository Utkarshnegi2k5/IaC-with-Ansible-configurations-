resource "aws_security_group" "Db_sg" {
  name        = "Db_sg"
  description = "Security group for Database instance"

  tags = {
    Name = "Db_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_db" {
  security_group_id = aws_security_group.Db_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_ingress_rule" "ssh_from_control_to_db" {
  security_group_id = aws_security_group.Db_sg.id
  referenced_security_group_id = aws_security_group.Control_sg.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}