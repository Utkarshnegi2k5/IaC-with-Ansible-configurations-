resource "aws_security_group" "Web_sg" {
  name        = "Web_sg"
  description = "Security group for Web instance"

  tags = {
    Name = "Web_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_web" {
  security_group_id = aws_security_group.Web_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" { 
  security_group_id = aws_security_group.Web_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "ssh_from_control_to_web" {
  security_group_id = aws_security_group.Web_sg.id
  referenced_security_group_id = aws_security_group.Control_sg.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Lets Prometheus on monitoring_p read Node Exporter on web_p
resource "aws_vpc_security_group_ingress_rule" "node_exporter_from_monitor" {
  security_group_id            = aws_security_group.Web_sg.id
  referenced_security_group_id = aws_security_group.Monitor_sg.id
  from_port                    = 9100
  ip_protocol                  = "tcp"
  to_port                      = 9100
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.Web_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.Web_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}