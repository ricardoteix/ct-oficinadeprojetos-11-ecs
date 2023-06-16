# Criando EFS
resource "aws_efs_file_system" "projeto-efs" {
  creation_token = "${var.tag-base}-efs" # Usado posteriormente com AWS CLI para montar o EFS
  tags = {
     Name = "${var.tag-base}"
   }
 }

resource "aws_efs_mount_target" "projeto-efs-mt" {
  count = length(module.network.private_subnets)
  file_system_id  = aws_efs_file_system.projeto-efs.id
  subnet_id = module.network.private_subnets[count.index].id
  security_groups = [module.security.sg-efs.id]

 }