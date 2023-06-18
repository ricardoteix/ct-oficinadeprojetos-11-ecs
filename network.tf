module "network" {
  source = "./module-network"
  region = var.regiao
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnet_cidr_blocks = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  private_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  enable_dns_hostnames = true
  enable_dns_support = true
  use_nat = var.use-nat-gateway
  tags-sufix = var.tag-base
}

# Network outputs
# module.network.vpc_id
# module.network.public_subnets[*]
# module.network.private_subnets[*]