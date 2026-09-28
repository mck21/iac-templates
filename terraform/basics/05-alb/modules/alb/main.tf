resource "aws_lb" "alb" {
  name               = "mi-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_id]
  subnets            = [var.subnet1_id, var.subnet2_id]

  tags = {
    Name = "ALB Linux"
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "mi-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_target_group_attachment" "ec2_1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.ec2_1_id
  port             = 80
}

resource "aws_lb_target_group_attachment" "ec2_2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.ec2_2_id
  port             = 80
}
