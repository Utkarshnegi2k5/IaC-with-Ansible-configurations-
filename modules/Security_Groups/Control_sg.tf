resource "aws_security_group" "Control_sg" {
  name        = "Control_sg"
  description = "Security group for Control instance"

  tags = {
    Name = "Control_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_control" {
  security_group_id = aws_security_group.Control_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "Web" {
  security_group_id = aws_security_group.Control_sg.id
  referenced_security_group_id = aws_security_group.Web_sg.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "Monitor" {
  security_group_id = aws_security_group.Control_sg.id
  referenced_security_group_id = aws_security_group.Monitor_sg.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "Database" {
  security_group_id = aws_security_group.Control_sg.id
  referenced_security_group_id = aws_security_group.Db_sg.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "control_all_out" {
  security_group_id = aws_security_group.Control_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}