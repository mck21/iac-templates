data "aws_ami" "ubuntu24" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-*-24.*-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "ubuntu24" {
  ami           = data.aws_ami.ubuntu24.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  tags = {
    Name = "Servidor Ubuntu 24"
  }
}

