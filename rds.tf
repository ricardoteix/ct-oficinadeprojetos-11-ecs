# Criando Subnet Group para RDS
resource "aws_db_subnet_group" "projeto-sn-db-group" {
  name       = "${var.tag-base}-sn-db-group"
  subnet_ids = setunion(
    module.network.public_subnets[*].id,
    module.network.private_subnets[*].id
  )
}


# Criando Instância do RDS
resource "aws_db_instance" "projeto-rds" {
  identifier = var.rds-identificador
  allocated_storage    = 10
  engine               = "postgres"
  engine_version       = "13.7"
  instance_class       = var.rds-tipo-instancia
  name                 = var.rds-nome-banco # Nome do schema criado inicialmente para usar no projeto
  username             = var.rds-nome-usuario
  password             = var.rds-senha-usuario
  # parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true # Para uso em produção, considerar mudar o valor para false 
  final_snapshot_identifier = "${var.rds-identificador}-bkp"
  publicly_accessible = false
  vpc_security_group_ids = [module.security.sg-db.id]
  db_subnet_group_name    = aws_db_subnet_group.projeto-sn-db-group.id
  tags = {
    Name = "${var.tag-base}-rds"
  }
}
