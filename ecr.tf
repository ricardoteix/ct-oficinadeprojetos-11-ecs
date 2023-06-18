# resource "aws_ecr_repository" "openproject-repo" {
#   name = "openproject-repo"
# }

# resource "null_resource" "image_to_ecr" {
#   provisioner "local-exec" {
#     command = <<EOF
# aws ecr get-login-password --region ${var.regiao} --profile ${var.profile}  | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.regiao}.amazonaws.com
# docker tag ${var.docker-image-name}:${var.docker-image-tag} ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.regiao}.amazonaws.com/${aws_ecr_repository.openproject-repo.name}:${var.docker-image-tag}
# docker push ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.regiao}.amazonaws.com/${aws_ecr_repository.openproject-repo.name}:${var.docker-image-tag}
#     EOF
#   }

#   # Depend on the ECR repository creation
#   depends_on = [aws_ecr_repository.openproject-repo]
# }


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
