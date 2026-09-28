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

resource "aws_launch_template" "lt_windows" {
  name_prefix   = "asg-windows-"
  image_id      = data.aws_ami.windows.id
  instance_type = var.instance_type

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ASG-Windows"
    }
  }
}

resource "aws_autoscaling_group" "asg" {
  name                = "asg-windows"
  desired_capacity    = 1
  min_size            = 1
  max_size            = 3
  vpc_zone_identifier = [var.subnet_id]

  launch_template {
    id      = aws_launch_template.lt_windows.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ASG-Windows"
    propagate_at_launch = true
  }
}
