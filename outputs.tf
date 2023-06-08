output "memcached-node-endpoint" {
  value = aws_elasticache_cluster.memcached.cache_nodes.0.address
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