# Endpoint
resource "aws_vpc_endpoint" "ecr_endpoint_api" {
  vpc_id              = module.network.vpc_id
  service_name        = "com.amazonaws.${var.regiao}.ecr.api"
  vpc_endpoint_type   = "Interface"

  private_dns_enabled = true
  security_group_ids  = [module.security.sg-ecr.id]
  subnet_ids          = module.network.private_subnets[*].id  # Select the appropriate private subnet

  tags = {
    Name = "ecr-endpoint-api"
  }
}

resource "aws_vpc_endpoint" "ecr_endpoint_dkr" {
  vpc_id              = module.network.vpc_id
  service_name        = "com.amazonaws.${var.regiao}.ecr.dkr"
  vpc_endpoint_type   = "Interface"

  private_dns_enabled = true
  security_group_ids  = [module.security.sg-ecr.id]
  subnet_ids          = module.network.private_subnets[*].id  # Select the appropriate private subnet

  tags = {
    Name = "ecr-endpoint-dkr"
  }
}

resource "aws_vpc_endpoint" "ecr_endpoint_logs" {
  vpc_id              = module.network.vpc_id
  service_name        = "com.amazonaws.${var.regiao}.logs"
  vpc_endpoint_type   = "Interface"

  private_dns_enabled = true
  security_group_ids  = [module.security.sg-ecr.id]
  subnet_ids          = module.network.private_subnets[*].id  # Select the appropriate private subnet

  tags = {
    Name = "ecr-endpoint-logs"
  }
}

resource "aws_vpc_endpoint" "ecr_endpoint_s3" {
  vpc_id              = module.network.vpc_id
  service_name        = "com.amazonaws.${var.regiao}.s3"
  vpc_endpoint_type   = "Gateway"

  route_table_ids = module.network.private_route_tables[*].id

  # private_dns_enabled = true
  # security_group_ids  = [module.security.sg-ecr.id]
  # subnet_ids          = module.network.private_subnets[*].id  # Select the appropriate private subnet

  tags = {
    Name = "ecr-endpoint-s3"
  }
}

# resource "aws_iam_policy" "s3_access_policy" {
#   name        = "s3-access-policy"
#   description = "Allows access to specific S3 bucket"

#   policy = <<EOF
# {
# 	"Version": "2008-10-17",
# 	"Statement": [
# 		{
# 			"Effect": "Allow",
# 			"Principal": "*",
# 			"Action": "s3:GetObject",
# 			"Resource": "arn:aws:s3:::prod-region-starport-layer-bucket/*"
# 		}
# 	]
# }
# EOF
# }

# data "aws_vpc_endpoint_service" "s3" {
#   service      = "s3"
#   service_type = "Gateway"
# }


# resource "aws_vpc_endpoint_service_allowed_principal" "ecr_endpoint_s3_principal" {
#   vpc_endpoint_service_id = data.aws_vpc_endpoint_service.s3.id
#   principal_arn           = aws_iam_policy.s3_access_policy.arn
# }
