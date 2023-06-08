resource "aws_elasticache_cluster" "memcached" {
    cluster_id           = "memcached-${var.tag-base}"
    engine               = "memcached"
    engine_version        = "1.5.16"
    node_type            = "cache.t3.micro"
    num_cache_nodes      = 1
    parameter_group_name = "default.memcached1.5"
    port                 = 11211
    security_group_ids = [module.security.sg-cache.id]
    subnet_group_name     = aws_elasticache_subnet_group.elasticache-subnet-group.name
}

resource "aws_elasticache_subnet_group" "elasticache-subnet-group" {
    name       = "elasticache-subnet-group"
    subnet_ids = setunion(
        module.network.public_subnets[*].id,
        module.network.private_subnets[*].id
    ) # Update with your desired subnet IDs
}