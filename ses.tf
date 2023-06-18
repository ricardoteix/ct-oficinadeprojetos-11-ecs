resource "aws_ses_email_identity" "user_email" {
  email = var.user-email
}

resource "aws_iam_user" "smtp_user" {
  name = "smtp_user"
}

resource "aws_iam_access_key" "smtp_user" {
  user = aws_iam_user.smtp_user.name
}

data "aws_iam_policy_document" "ses_sender" {
  statement {
    actions   = ["ses:SendRawEmail"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ses_sender" {
  name        = "ses_sender"
  description = "Allows sending of e-mails via Simple Email Service"
  policy      = data.aws_iam_policy_document.ses_sender.json
}

resource "aws_iam_user_policy_attachment" "ses-attach" {
  user       = aws_iam_user.smtp_user.name
  policy_arn = aws_iam_policy.ses_sender.arn
}

# Endpoint
resource "aws_vpc_endpoint" "ses_endpoint" {
  vpc_id              = module.network.vpc_id
  service_name        = "com.amazonaws.${var.regiao}.email-smtp"
  vpc_endpoint_type   = "Interface"

  private_dns_enabled = true
  security_group_ids  = [module.security.sg-ses.id]
  subnet_ids          = [module.network.private_subnets[0].id]  # Select the appropriate private subnet

  tags = {
    Name = "ses-endpoint"
  }
}
