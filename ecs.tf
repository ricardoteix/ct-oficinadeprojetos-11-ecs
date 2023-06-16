# Documentação sobre S3
# https://www.openproject.org/docs/installation-and-operations/configuration/#attachments-storage
# https://github.com/opf/openproject/blob/dev/docs/installation-and-operations/configuration/README.md#attachment-storage-type

resource "aws_ecs_task_definition" "openproject" {
  family                   = "openproject"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 2048
  memory                   = 4096
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  
  volume {
    name = "efs-volume"

    efs_volume_configuration {
      file_system_id          = aws_efs_file_system.projeto-efs.id
      transit_encryption      = "ENABLED"
      transit_encryption_port = 2049
    }
  }

  container_definitions    = <<DEFINITION
[
  {
    "name": "openproject",
    "image": "openproject/community:12",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/openproject",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "mountPoints": [
      {
        "sourceVolume": "efs-volume",
        "containerPath": "/var/openproject/assets/"
      }
    ],
    "environment": [
      {
        "name": "OPENPROJECT_HTTPS",
        "value": "false"
      },
      {
        "name": "OPENPROJECT_SECRET_KEY_BASE",
        "value": "secret"
      },
      {
        "name": "OPENPROJECT_HOST__NAME",
        "value": "${aws_lb.openproject.dns_name}"
      },
      {
        "name": "OPENPROJECT_CACHE__MEMCACHE__SERVER",
        "value": "${aws_elasticache_cluster.memcached.cache_nodes.0.address}:11211"
      },
      {
        "name": "DATABASE_URL",
        "value": "postgresql://${var.rds-nome-usuario}:${var.rds-senha-usuario}@${aws_db_instance.projeto-rds.address}:5432/openproject"
      },
      {
        "name": "OPENPROJECT_ATTACHMENTS__STORAGE",
        "value": "fog"
      },
      {
        "name": "OPENPROJECT_FOG_CREDENTIALS_AWS__ACCESS__KEY__ID",
        "value": "${aws_iam_access_key.s3_user_key.id}"
      },
      {
        "name": "OPENPROJECT_FOG_CREDENTIALS_AWS__SECRET__ACCESS__KEY",
        "value": "${aws_iam_access_key.s3_user_key.secret}"
      },
      {
        "name": "OPENPROJECT_FOG_CREDENTIALS_PROVIDER",
        "value": "AWS"
      },
      {
        "name": "OPENPROJECT_FOG_CREDENTIALS_REGION",
        "value": "${var.regiao}"
      },
      {
        "name": "OPENPROJECT_FOG_DIRECTORY",
        "value": "${aws_s3_bucket.projeto-static.bucket}"
      },
      {
        "name": "RAILS_ENV",
        "value": "production"
      },
      {
        "name": "OPENPROJECT_EMAIL__DELIVERY__METHOD",
        "value": "smtp"
      },
      {
        "name": "OPENPROJECT_SMTP__ADDRESS",
        "value": "email-smtp.${var.regiao}.amazonaws.com"
      },
      {
        "name": "OPENPROJECT_SMTP__USER__NAME",
        "value": "${aws_iam_access_key.smtp_user.id}"
      },
      {
        "name": "OPENPROJECT_SMTP__PASSWORD",
        "value": "${aws_iam_access_key.smtp_user.ses_smtp_password_v4}"
      },
      {
        "name": "OPENPROJECT_SMTP__PORT",
        "value": "587"
      },
      {
        "name": "OPENPROJECT_SMTP__DOMAIN",
        "value": "${aws_lb.openproject.dns_name}"
      },
      {
        "name": "OPENPROJECT_SMTP__AUTHENTICATION",
        "value": "login"
      },
      {
        "name": "OPENPROJECT_SMTP__ENABLE__STARTTLS__AUTO",
        "value": "true"
      }
    ],
    "requires_compatibilities": ["FARGATE"],
    "cpu": 2048,
    "memory": 4096,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080
      }
    ]
  }
]    
DEFINITION
}

resource "aws_ecs_cluster" "openproject-cluster" {
  name = "openproject-cluster" 
}

resource "aws_ecs_service" "openproject" {
  name            = "openproject"
  cluster         = aws_ecs_cluster.openproject-cluster.id
  task_definition = aws_ecs_task_definition.openproject.arn
  desired_count   = 1
  launch_type = "FARGATE"
  platform_version = "LATEST"
  deployment_maximum_percent = 200
  deployment_minimum_healthy_percent = 100
  network_configuration {
    subnets = setunion(
        # module.network.public_subnets[*].id,
        module.network.private_subnets[*].id
    )
    security_groups = [module.security.sg-web.id]
    assign_public_ip = false
  }
  deployment_controller {
    type = "ECS"
  }
  lifecycle {
    // Define a "create_before_destroy" behavior to update the service
    create_before_destroy = true
  }
  load_balancer{
    container_name = "openproject"
    container_port = 8080
    target_group_arn = aws_lb_target_group.openproject.arn
  }
}

resource "aws_cloudwatch_log_group" "openproject" {
  name              = "/ecs/openproject"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_stream" "openproject" {
  name           = "ecs"
  log_group_name = aws_cloudwatch_log_group.openproject.name
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_task_execution_role.name
}

resource "aws_iam_role_policy_attachment" "efs_mount_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientReadWriteAccess"  // Replace with the appropriate EFS policy ARN
  role       = aws_iam_role.ecs_task_execution_role.name
}

# ELB

resource "aws_lb" "openproject" {
  name               = "openproject-lb"
  load_balancer_type = "application"
  subnets            = module.network.public_subnets[*].id
  security_groups    = [module.security.sg-elb.id]
}

resource "aws_lb_target_group" "openproject" {
  name        = "openproject-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.network.vpc_id
  health_check {
    path = "/"
  }
}

resource "aws_lb_listener" "openproject" {
  load_balancer_arn = aws_lb.openproject.arn
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.openproject.arn
  }
}

# ASG
resource "aws_appautoscaling_target" "ecs_service_as" {
  max_capacity = var.max-tasks
  min_capacity = var.min-tasks
  resource_id = "service/${aws_ecs_cluster.openproject-cluster.name}/${aws_ecs_service.openproject.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}

resource "aws_appautoscaling_policy" "scale-to-cpu" {
  name = "scale-to-cpu"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.ecs_service_as.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_service_as.scalable_dimension
  service_namespace = aws_appautoscaling_target.ecs_service_as.service_namespace

  target_tracking_scaling_policy_configuration {
    scale_in_cooldown  = 30
    scale_out_cooldown = 30

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 30
  }
}

# resource "aws_appautoscaling_policy" "scale-to-memory" {
#   name               = "scale-to-memory"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.ecs_service_as.resource_id
#   scalable_dimension = aws_appautoscaling_target.ecs_service_as.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.ecs_service_as.service_namespace

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageMemoryUtilization"
#     }

#     target_value = 70
#   }
# }

# resource "aws_appautoscaling_policy" "scale-to-cpu" {
#   name = "scale-to-cpu"
#   policy_type = "TargetTrackingScaling"
#   resource_id = aws_appautoscaling_target.ecs_service_as.resource_id
#   scalable_dimension = aws_appautoscaling_target.ecs_service_as.scalable_dimension
#   service_namespace = aws_appautoscaling_target.ecs_service_as.service_namespace

#   target_tracking_scaling_policy_configuration {
#     adjustment_type         = "ChangeInCapacity"
#     cooldown = 60

#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageCPUUtilization"
#     }

#     target_value = 30
#   }
# }
