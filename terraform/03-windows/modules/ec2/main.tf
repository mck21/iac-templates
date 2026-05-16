data "aws_ami" "windows" {
  most_recent = true
  owners      = ["801119661308"] # Amazon

  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "windows" {
  ami           = data.aws_ami.windows.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  tags = {
    Name = "Servidor Windows"
  }
}
