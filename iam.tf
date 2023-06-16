# IAM User S3
resource "aws_iam_user" "s3_user" {
  name = "s3_user-${var.tag-base}"
  path = "/"

  tags = {
    tag-key = "${var.tag-base}"
  }
}

resource "aws_iam_access_key" "s3_user_key" {
  user = aws_iam_user.s3_user.name
}

resource "aws_iam_user_policy" "s3_user_policy" {
  name = "s3_user_policy"
  user = aws_iam_user.s3_user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "VisualEditor0",
        "Effect": "Allow",
        "Action": [
            "s3:ListBucket"
        ],
        "Resource": [
            "arn:aws:s3:::${aws_s3_bucket.projeto-static.bucket}"
        ]
    },
    {
        "Sid": "VisualEditor1",
        "Effect": "Allow",
        "Action": [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject"
        ],
        "Resource": "arn:aws:s3:::${aws_s3_bucket.projeto-static.bucket}/*"
    }
  ]
}
EOF
}

# resource "aws_iam_user" "readonly_user" {
#   name = "projeto11"
#   force_destroy = true
# }

# resource "aws_iam_user_policy_attachment" "readonly_user_policy" {
#   user       = aws_iam_user.readonly_user.name
#   policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
# }

# resource "aws_iam_user_login_profile" "readonly_user_login_profile" {
#   user    = aws_iam_user.readonly_user.name
#   password_reset_required = false
# }

# output "readonly_user_credentials" {
#   value = {
#     username = aws_iam_user.readonly_user.name
#     password = aws_iam_user_login_profile.readonly_user_login_profile.encrypted_password
#   }
# }