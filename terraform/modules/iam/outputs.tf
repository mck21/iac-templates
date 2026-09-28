output "ec2_instance_profile_name" {
  value = try(aws_iam_instance_profile.ec2_ssm[0].name, null)
}

output "ec2_instance_profile_arn" {
  value = try(aws_iam_instance_profile.ec2_ssm[0].arn, null)
}

output "ec2_role_arn" {
  value = try(aws_iam_role.ec2_ssm[0].arn, null)
}
