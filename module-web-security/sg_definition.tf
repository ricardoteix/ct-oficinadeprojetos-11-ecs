
# Criando Security Groups
resource "aws_security_group" "sg_projeto_web" {
  name        = "sg_${var.tags-sufix}_web"
  description = "Allow web inbound traffic"
  vpc_id      = var.vpc-id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  ingress {
    description      = "HTTP"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg-${var.tags-sufix}-web"
  }
}

resource "aws_security_group" "sg_projeto_db" {
  name        = "sg_${var.tags-sufix}_db"
  description = "Allow web inbound traffic"
  vpc_id      =  var.vpc-id

  ingress {
    description      = "${var.db-name}"
    from_port        = var.db-port
    to_port          = var.db-port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg-${var.tags-sufix}-db"
  }

}

# Criando Security Group para EFS
resource "aws_security_group" "sg_projeto_efs" {
  name = "sg_${var.tags-sufix}_efs"
  description= "Allos inbound efs traffic from ec2"
  vpc_id =  var.vpc-id

  ingress {
    security_groups = [aws_security_group.sg_projeto_web.id]
    from_port = 2049
    to_port = 2049 
    protocol = "tcp"
  }     
      
  egress {
    security_groups = [aws_security_group.sg_projeto_web.id]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }

    tags = {
      Name = "sg-${var.tags-sufix}-efs"
    }
 }


resource "aws_security_group" "sg_projeto_elb" {
  name        = "sg_${var.tags-sufix}_elb"
  description = "Allow web ELB"
  vpc_id      =  var.vpc-id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg-${var.tags-sufix}-elb"
  }
}

resource "aws_security_group" "sg_projeto_cache" {
  name        = "sg_${var.tags-sufix}_cache"
  description = "Allow web ELB"
  vpc_id      =  var.vpc-id

  ingress {
    description      = "MEMCACHED"
    from_port        = 1121
    to_port          = 1121
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg-${var.tags-sufix}-cache"
  }
}
