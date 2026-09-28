resource "aws_instance" "mi_servidor" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  tags = {
    Name = "Servidor en Subred Pública"
  }
}