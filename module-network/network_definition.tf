# Criando a VPC
resource "aws_vpc" "vpc-projeto" {
    cidr_block = var.vpc_cidr_block
		enable_dns_hostnames = var.enable_dns_hostnames # DNS hostnames
 		enable_dns_support = var.enable_dns_support # DNS resolution
    tags = {
        Name = "vpc-${var.tags-sufix}"
    }
}

# Criando o Internert Gateway
resource "aws_internet_gateway" "igw-projeto" {
  vpc_id = aws_vpc.vpc-projeto.id
  tags = {
    Name = "igw-${var.tags-sufix}"
  }
}

# Criando a Route Table pública
resource "aws_route_table" "rt-projeto-public" {
  vpc_id = aws_vpc.vpc-projeto.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-projeto.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.igw-projeto.id
  }

  tags = {
    Name = "rt-${var.tags-sufix}-public"
  }
}

# Criando a Route Table privada
resource "aws_route_table" "rt-projeto-private" {
  vpc_id = aws_vpc.vpc-projeto.id
  route = []
  tags = {
    Name = "rt-${var.tags-sufix}-private"
  }
}

# Criando Subnets Públicas
resource "aws_subnet" "sn-projeto-publics" {
  count = length(var.public_subnet_cidr_blocks)
  vpc_id = aws_vpc.vpc-projeto.id
  cidr_block = var.public_subnet_cidr_blocks[count.index]
  availability_zone = "${var.region}${var.zones[count.index % 3]}"
  map_public_ip_on_launch = true
  tags = {
    Name = "sn-${var.tags-sufix}-public-${count.index + 1}"
  }
}

# Criando Subnets Privadas
resource "aws_subnet" "sn-projeto-privates" {
  count = length(var.private_subnet_cidr_blocks)
  vpc_id = aws_vpc.vpc-projeto.id
  cidr_block = var.private_subnet_cidr_blocks[count.index]
  availability_zone = "${var.region}${var.zones[count.index % 3]}"
  tags = {
    Name = "sn-${var.tags-sufix}-private-${count.index + 1}"
  }
}

# Criando a relação entre Subnet e Route Table
resource "aws_route_table_association" "rt-projeto-assoc-pb" {
  count = length(var.public_subnet_cidr_blocks)
  subnet_id      = aws_subnet.sn-projeto-publics[count.index].id
  route_table_id = aws_route_table.rt-projeto-public.id
}

resource "aws_route_table_association" "rt-projeto-assoc-pv" {
  count = length(var.private_subnet_cidr_blocks)
  subnet_id      = aws_subnet.sn-projeto-privates[count.index].id
  route_table_id = aws_route_table.rt-projeto-private.id
}

# Definindo Main Route
resource "aws_main_route_table_association" "rt-projeto-assoc-main" {
  vpc_id         = aws_vpc.vpc-projeto.id
  route_table_id = aws_route_table.rt-projeto-private.id
}

# Network ACL criado automático com tudo Allow para todas as subnets
