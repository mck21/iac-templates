output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "active_color" {
  value = var.active_color
}

output "listener_weights" {
  value = local.listener_weights
}

output "asg_names" {
  value = { for k, m in module.asg : k => m.asg_name }
}
