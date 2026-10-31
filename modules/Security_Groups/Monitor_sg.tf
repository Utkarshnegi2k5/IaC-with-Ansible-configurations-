resource "aws_security_group" "Monitor_sg" {
  name        = "Monitor_sg"
  description = "Security group for Montitoring instance"

  tags = {
    Name = "Monitor_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_monitor" {
  security_group_id = aws_security_group.Monitor_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "ssh_from_control_to_monitor" {
  security_group_id = aws_security_group.Monitor_sg.id
  referenced_security_group_id = aws_security_group.Control_sg.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Prometheus API, only for the backend on web_p (needed later)
resource "aws_vpc_security_group_ingress_rule" "prometheus_from_web" {
  security_group_id            = aws_security_group.Monitor_sg.id
  referenced_security_group_id = aws_security_group.Web_sg.id
  from_port                    = 9090
  ip_protocol                  = "tcp"
  to_port                      = 9090
}

# Lets monitoring_p download Prometheus/Grafana and scrape web_p
resource "aws_vpc_security_group_egress_rule" "monitor_all_out" {
  security_group_id = aws_security_group.Monitor_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Grafana in your browser. FILL: your public IP from https://checkip.amazonaws.com (keep the /32)
resource "aws_vpc_security_group_ingress_rule" "grafana_from_my_ip" {
  security_group_id = aws_security_group.Monitor_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3000
  ip_protocol       = "tcp"
  to_port           = 3000
}