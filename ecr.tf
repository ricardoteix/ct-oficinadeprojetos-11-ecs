# Endpoint
resource "aws_vpc_endpoint" "ecr_endpoint_api" {
  count = var.use-nat-gateway ? 1 : 0
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
  count = var.use-nat-gateway ? 1 : 0
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
  count = var.use-nat-gateway ? 1 : 0
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
  count = var.use-nat-gateway ? 1 : 0
  vpc_id              = module.network.vpc_id
  service_name        = "com.amazonaws.${var.regiao}.s3"
  vpc_endpoint_type   = "Gateway"

  route_table_ids = module.network.private_route_tables[*].id

  tags = {
    Name = "ecr-endpoint-s3"
  }
}
