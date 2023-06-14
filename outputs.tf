output "memcached-node-endpoint" {
  value = aws_elasticache_cluster.memcached.cache_nodes.0.address
}

output "projeto-efs_id" {
  value = aws_efs_file_system.projeto-efs.id
}

output "openproject-lb-dns" {
  // Existing output

  // Add the following output to display the CloudWatch Logs group and stream names
  value = {
    lb_dns       = aws_lb.openproject.dns_name
    log_group    = aws_cloudwatch_log_group.openproject.name
    log_stream   = aws_cloudwatch_log_stream.openproject.name
  }
}

resource "local_file" "private_key" {
    content  = <<-EOT
export const LOADBALANCER_DNS = "${aws_lb.openproject.dns_name}";
export const API_KEY = "<Obter no OpenProject>";
    EOT
    filename = "./k6-load-test/env.js"
}

output "nome-bucket" {
  value = var.nome-bucket
}

output "smtp_username" {
  value = aws_iam_access_key.smtp_user.id
}

output "smtp_password" {
  value = aws_iam_access_key.smtp_user.ses_smtp_password_v4
  sensitive = true
}