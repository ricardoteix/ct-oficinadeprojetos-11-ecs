# Arquivo com a definição das variáveis. O arquivo poderia ter qualquer outro nome, ex. valores.tf

variable "regiao" {
  description = "Região da AWS para provisionamento"
  type        = string
  default     = "us-east-1"
}

variable "profile" {
  description = "Profile com as credenciais criadas no IAM"
  type = string
}

variable "tag-base" {
  description = "Nome utilizado para nomenclaruras no projeto"
  type        = string
  default     = "projeto"
}

variable "health_check" {
   type = map(string)
   default = {
      "timeout"  = "10"
      "interval" = "20"
      "path"     = "/"
      "port"     = "80"
      "unhealthy_threshold" = "2"
      "healthy_threshold" = "3"
    }
}

# RDS

variable "rds-identificador" {
  description = "Tipo da instância do RDS"
  type        = string
  default     = "projeto-db"
}

variable "rds-tipo-instancia" {
  description = "Tipo da instância do RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "rds-nome-banco" {
  description = "Nome do schema criado inicialmente para usar no Projeto"
  type        = string
  default     = "projeto_db"
}

variable "rds-nome-usuario" {
  description = "Nome do usuário administrador da instância RDS"
  type        = string
  
  # default     = "nao colocar valor padrão aqui" # Não deixar padrão para versionar com git.
  # Veja o arquivo terraform.tfvars.exemplo para definir um valor fixo para esta variável.
}

variable "rds-senha-usuario" {
  description = "Senha do usuário administrador da instância RDS"
  type        = string

  # default     = "nao colocar valor padrão aqui" # Não deixar padrão para versionar com git.
  # Veja o arquivo terraform.tfvars.exemplo para definir um valor fixo para esta variável.
}

# S3
variable "nome-bucket" {
  description = "Nome do bucket para configurar no Projeto"
  type = string
  default = "projeto-files"  # Como o bucket deve ser unico em toda a AWS, sugiro modifica este nome para evitar conflito.
}

variable "user-email" {
  description = "Email do Admin para teste do SES"
  type = string
}

variable "min-tasks" {
  description = "Quantidade mínima de tasks no autoscaling"
  type = number
  default = 1
}

variable "max-tasks" {
  description = "Quantidade máxima de tasks no autoscaling"
  type = number
  default = 2
}

variable "ecs-vcpu" {
  description = "Quantidade máxima de tasks no autoscaling"
  type = number
  default = (2 * 1024)
}

variable "ecs-memory" {
  description = "Quantidade máxima de tasks no autoscaling"
  type = number
  default = (4 * 1024)
}

variable "image-ecr-uri" {
  description = "Endereço da imagem no ECR"
  type = string
}

variable "use-nat-gateway" {
  description = "Especifica se serão criados NAT Gateways para cada Subnet pública."
  type = bool
  default = false
}