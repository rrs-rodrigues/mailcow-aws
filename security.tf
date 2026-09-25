resource "aws_key_pair" "mail_key" {
  key_name   = "mailcow-key"
  public_key = var.public_key_path
}

resource "aws_security_group" "mailcow_sg" {
  name        = "mailcow-sg"
  description = "Security group for Mailcow server"


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_ip]
  }

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SMTP access"
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "IMAP"
    from_port = 143
    to_port = 143
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "IMAPS"
    from_port = 993
    to_port = 993
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "POP3"
    from_port = 110
    to_port = 110
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "POP3S"
    from_port = 995
    to_port = 995
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Sieve"
    from_port = 4190
    to_port = 4190
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { 
    Name = "mailcow-sg"
  }
}