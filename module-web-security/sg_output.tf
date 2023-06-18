output "sg-web" {
  value = aws_security_group.sg_projeto_web
}

output "sg-db" {
  value = aws_security_group.sg_projeto_db
}

output "sg-elb" {
  value = aws_security_group.sg_projeto_elb
}

output "sg-efs" {
  value = aws_security_group.sg_projeto_efs
}

output "sg-cache" {
  value = aws_security_group.sg_projeto_cache
}

output "sg-ses" {
  value = aws_security_group.sg_projeto_ses
}

output "sg-ecr" {
  value = aws_security_group.sg_projeto_ecr
}