variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "public_key_path" {
  description = "Path to the public key file for SSH access"
  type        = string
}


variable "admin_ip" {
  description = "IP address of the administrator for SSH access"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the Mailcow server"
  type        = string
  default     = "m7i-flex.large"
}

variable "ubuntu_ami_id" {
  description = "AMI ID for the Ubuntu server"
  type        = string
  default     = "ami-0e86e20dae9224db8" # Example AMI ID, replace with a valid one for your region
}

variable "mailcow_hostname" {
  type        = string
  description = "FQDN do servidor de e-mail"
  default     = "mail.rrsbox.dpdns.org"
}

variable "mailcow_timezone" {
  type        = string
  description = "Fuso horário para o Mailcow"
  default     = "America/Sao_Paulo"
}