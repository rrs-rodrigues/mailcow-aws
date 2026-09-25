resource "aws_instance" "mailcow_server" {
    ami           = var.ubuntu_ami_id
    instance_type = var.instance_type
    key_name      = "mailcow-key"

    vpc_security_group_ids = [aws_security_group.mailcow_sg.id]
    root_block_device {
        volume_size = 40 #SSD
        volume_type = "gp3"
        delete_on_termination = true
    }

    user_data = <<-EOF
              #!/bin/bash
              set -e

              # 1. Configuração de 4GB de SWAP (Obrigatório para ClamAV/Rspamd)
              fallocate -l 4G /swapfile
              chmod 600 /swapfile
              mkswap /swapfile
              swapon /swapfile
              echo '/swapfile none swap sw 0 0' >> /etc/fstab

              # 2. Atualização e dependências
              apt-get update -y
              apt-get install -y curl git apt-transport-https ca-certificates gnupg lsb-release

              # 3. Instalação oficial do Docker e Compose Plugin
              install -m 0755 -d /etc/apt/keyrings
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
              chmod a+r /etc/apt/keyrings/docker.asc

              echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
              $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

              apt-get update -y
              apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
              systemctl enable --now docker

              # 4. Clonar repositório do Mailcow
              cd /opt
              git clone https://github.com/mailcow/mailcow-dockerized
              cd mailcow-dockerized

              # 5. Execução não-interativa do generate_config.sh
              # Alimenta o script com Hostname, Timezone e Branch padrão
              printf "%s\n%s\n1\n" "${var.mailcow_hostname}" "${var.mailcow_timezone}" | ./generate_config.sh

              # 6. Criação do serviço systemd para gerenciar o ciclo de vida dos contêineres
              cat << 'SERVICE' > /etc/systemd/system/mailcow.service
              [Unit]
              Description=Mailcow Docker Compose Application
              Requires=docker.service
              After=docker.service

              [Service]
              Type=oneshot
              RemainAfterExit=true
              WorkingDirectory=/opt/mailcow-dockerized
              ExecStart=/usr/bin/docker compose up -d --remove-orphans
              ExecStop=/usr/bin/docker compose down

              [Install]
              WantedBy=multi-user.target
              SERVICE

              systemctl daemon-reload
              systemctl enable mailcow.service

              # 7. Download das imagens e inicialização imediata
              docker compose pull
              docker compose up -d
              EOF

    tags = {
        Name = "mailcow-server-ec2"
    }
  
}