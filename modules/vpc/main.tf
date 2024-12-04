# modules/vpc/main.tf

# The VPC - This is our main network container
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  # EKS requires DNS hostnames and support
  tags = {
    Name                                            = "${var.app_name}-${var.environment}-vpc"
    Environment                                     = var.environment
    "kubernetes.io/cluster/${var.app_name}-${var.environment}" = "shared"
  }
}
# Create security group for databases
resource "aws_security_group" "database" {
  name        = "${var.app_name}-${var.environment}-database-sg"
  description = "Security group for database access"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    cidr_blocks     = var.private_subnet_cidrs
    description     = "Allow PostgreSQL access from private subnets"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "${var.app_name}-${var.environment}-database-sg"
    Environment = var.environment
  }
}
# Create security group for Redis
resource "aws_security_group" "redis" {
  name        = "${var.app_name}-${var.environment}-redis-sg"
  description = "Security group for Redis access"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    cidr_blocks     = var.private_subnet_cidrs
    description     = "Allow Redis access from private subnets"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "${var.app_name}-${var.environment}-redis-sg"
    Environment = var.environment
  }
}

# Internet Gateway - Allows our public subnets to access the internet
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.app_name}-${var.environment}-igw"
    Environment = var.environment
  }
}

# Elastic IP for NAT Gateway - Gives our private subnets outbound internet access
# In modules/vpc/main.tf, update the EIP resource


resource "aws_eip" "nat" {
  
  tags = {
    Name        = "${var.app_name}-${var.environment}-nat-eip"
    Environment = var.environment
  }
}

# NAT Gateway - Allows private subnet resources to access the internet
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id  # Place NAT Gateway in first public subnet

  tags = {
    Name        = "${var.app_name}-${var.environment}-nat"
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.main]
}

# Public subnets - For resources that need direct internet access
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  map_public_ip_on_launch = true

  # Tags required for EKS to discover subnets for load balancers
  tags = {
    Name                                            = "${var.app_name}-${var.environment}-public-${count.index + 1}"
    Environment                                     = var.environment
    "kubernetes.io/cluster/${var.app_name}-${var.environment}" = "shared"
    "kubernetes.io/role/elb"                        = "1"
  }
}

# Private subnets - For resources that don't need direct internet access
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  # Tags required for EKS to discover subnets for internal load balancers
  tags = {
    Name                                            = "${var.app_name}-${var.environment}-private-${count.index + 1}"
    Environment                                     = var.environment
    "kubernetes.io/cluster/${var.app_name}-${var.environment}" = "shared"
    "kubernetes.io/role/internal-elb"               = "1"
  }
}

# Route table for public subnets - Routes traffic to the internet gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "${var.app_name}-${var.environment}-public-rt"
    Environment = var.environment
  }
}

# Route table for private subnets - Routes traffic through the NAT gateway
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name        = "${var.app_name}-${var.environment}-private-rt"
    Environment = var.environment
  }
}

# Associate public subnets with the public route table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Associate private subnets with the private route table
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
# Add to your existing VPC module or create a new networking module

resource "aws_security_group" "alb" {
  name        = "${var.app_name}-${var.environment}-alb-sg"
  description = "Security group for application load balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS traffic"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.app_name}-${var.environment}-alb-sg"
    Environment = var.environment
  }
}