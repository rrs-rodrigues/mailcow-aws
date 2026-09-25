output "mailcow_public_ip" {
  value = aws_eip.mailcow_eip.public_ip
  description = "IP Estatico do servidor Mailcow"
}

output "mailcow_instance_id" {
  value = aws_instance.mailcow_server.id
  description = "ID da instância do servidor Mailcow"
}

output "ssh_command" {
  value = "ssh ubuntu@${aws_eip.mailcow_eip.public_ip}"
  description = "Comando SSH para acessar o servidor Mailcow"
}