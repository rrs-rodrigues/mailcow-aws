resource "aws_eip" "mailcow_eip" {
    instance = aws_instance.mailcow_server.id
    domain   = "vpc"
    tags = {
        Name = "mailcow-eip"
    }
}
