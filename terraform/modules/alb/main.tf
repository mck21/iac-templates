resource "aws_lb" "this" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids
  tags               = merge(var.tags, { Name = var.name })
}

resource "aws_lb_target_group" "this" {
  for_each = var.target_groups

  name     = substr("${var.name}-${each.key}", 0, 32)
  port     = each.value.port
  protocol = each.value.protocol
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }

  tags = merge(var.tags, { Name = "${var.name}-${each.key}" })
}

locals {
  # If weights omitted, send 100% to the first TG key (sorted for stability).
  effective_weights = length(var.listener_weights) > 0 ? var.listener_weights : {
    for k in keys(var.target_groups) : k => (k == sort(keys(var.target_groups))[0] ? 100 : 0)
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"

    forward {
      dynamic "target_group" {
        for_each = var.target_groups
        content {
          arn    = aws_lb_target_group.this[target_group.key].arn
          weight = lookup(local.effective_weights, target_group.key, 0)
        }
      }
    }
  }
}
