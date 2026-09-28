data "aws_iam_policy_document" "ec2_assume" {
  count = var.enable_ec2_ssm ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_ssm" {
  count = var.enable_ec2_ssm ? 1 : 0

  name               = "${var.name}-ec2-ssm"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume[0].json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  count = var.enable_ec2_ssm ? 1 : 0

  role       = aws_iam_role.ec2_ssm[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm" {
  count = var.enable_ec2_ssm ? 1 : 0

  name = "${var.name}-ec2-ssm"
  role = aws_iam_role.ec2_ssm[0].name
  tags = var.tags
}
