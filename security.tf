module "security" {
  source = "./module-web-security"
  db-name = "PostgreSQL"
  db-port = 5432
  region = var.regiao
  tags-sufix = var.tag-base
  vpc-id = module.network.vpc_id
}

# Security outputs
# module.security.sg-web
# module.security.sg-elb
# module.security.sg-db
# module.security.sg-efs
# module.security.sg-cache
# module.security.sg-ses

