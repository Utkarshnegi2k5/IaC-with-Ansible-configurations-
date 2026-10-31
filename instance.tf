module "security_groups" {
  source = "./modules/Security_Groups"
}

resource "aws_instance" "control_p" {
  ami                    = data.aws_ami.amiID.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.Project_key.key_name
  vpc_security_group_ids = [module.security_groups.control_sg_id]
  availability_zone      = var.zone

  tags = {
    Name = "Control evironment"
  }
}

resource "aws_instance" "web_p" {
  ami                    = data.aws_ami.amiID.id
  key_name               = aws_key_pair.Project_key.key_name
  instance_type          = "t3.micro"
  vpc_security_group_ids = [module.security_groups.web_sg_id]
  availability_zone      = var.zone

  tags = {
    Name = "web application"
  }
}

resource "aws_instance" "db_p" {
  ami                    = data.aws_ami.amiID.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.Project_key.key_name
  vpc_security_group_ids = [module.security_groups.db_sg_id]
  availability_zone      = var.zone

  tags = {
    Name = "Database"
  }
}

resource "aws_instance" "monitoring_p" {
  ami                    = data.aws_ami.amiID.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.Project_key.key_name
  vpc_security_group_ids = [module.security_groups.monitor_sg_id]
  availability_zone      = var.zone

  tags = {
    Name = "Monitor"
  }
}
