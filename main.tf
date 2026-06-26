# CREATE A VPC
resource "aws_vpc" "cv_first_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "cv-first-vpc"
  }
}

# CREATE first PRIVATE SUBNET
resource "aws_subnet" "cv_first_pvt_subnet" {
  cidr_block = "10.0.1.0/24"
  vpc_id     = aws_vpc.cv_first_vpc.id
  availability_zone = "ap-south-1a"

  tags = {
    Name = "cv-first-pvt-subnet"
  }
}
# CREATE second PRIVATE SUBNET
resource "aws_subnet" "cv_secoond_pvt_subnet" {
  cidr_block = "10.0.3.0/24"
  vpc_id = aws_vpc.cv_first_vpc.id
  availability_zone = "ap-south-1b"

  tags = {
    Name = "cv_secoond_pvt_subnet"
  }
  
}

# CREATE PUBLIC SUBNET
resource "aws_subnet" "cv_first_public_subnet" {
  cidr_block = "10.0.2.0/24"
  vpc_id     = aws_vpc.cv_first_vpc.id

  map_public_ip_on_launch = true

  tags = {
    Name = "cv-first-public-subnet"
  }
}

# CREATE INTERNET GATEWAY
resource "aws_internet_gateway" "cv_first_ig" {
  vpc_id = aws_vpc.cv_first_vpc.id

  tags = {
    Name = "cv-first-ig"
  }
}

# CREATE PUBLIC ROUTE TABLE
resource "aws_route_table" "cv_first_public_route_tbl" {
  vpc_id = aws_vpc.cv_first_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cv_first_ig.id
  }

  tags = {
    Name = "cv-first-public-route-tbl"
  }
}

# CREATE PUBLIC ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "cv_first_public_rt_association" {
  route_table_id = aws_route_table.cv_first_public_route_tbl.id
  subnet_id      = aws_subnet.cv_first_public_subnet.id
}

# CREATE ELASTIC IP
resource "aws_eip" "cv_first_eip" {
  domain = "vpc"
}

# CREATE NAT GATEWAY
resource "aws_nat_gateway" "cv_first_natgateway" {
  allocation_id = aws_eip.cv_first_eip.id
  subnet_id     = aws_subnet.cv_first_public_subnet.id

  tags = {
    Name = "cv-first-natgateway"
  }

  depends_on = [aws_internet_gateway.cv_first_ig]
}

# CREATE PRIVATE ROUTE TABLE
resource "aws_route_table" "cv_first_private_route_table" {
  vpc_id = aws_vpc.cv_first_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.cv_first_natgateway.id
  }

  tags = {
    Name = "cv-first-private-route-table"
  }
}

# CREATE PRIVATE ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "cv_first_pvt_rt_association" {
  route_table_id = aws_route_table.cv_first_private_route_table.id
  subnet_id      = aws_subnet.cv_first_pvt_subnet.id
}

# CREATE SECURITY GROUP
resource "aws_security_group" "cv_ec2_security" {
  name   = "cv-ec2-security"
  vpc_id = aws_vpc.cv_first_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# CREATE EC2 INSTANCE
resource "aws_instance" "cv_first_ec2_instance" {
  ami           = "ami-0f559c3642608c138"
  instance_type = "t3.micro"
  associate_public_ip_address = true

  subnet_id = aws_subnet.cv_first_public_subnet.id

  key_name = "cv-first-keypair"

  vpc_security_group_ids = [
    aws_security_group.cv_ec2_security.id
  ]

  tags = {
    Name = "cv_first_ec2_instance"
  }
}


# CREATE RDS POSTGRESQL

# SUBNET GROUP
resource "aws_db_subnet_group" "cv_first_postgres" {
  name = "cv_first_postgres"

  subnet_ids = [
    aws_subnet.cv_first_pvt_subnet.id,
    aws_subnet.cv_secoond_pvt_subnet.id
  ]
}

# RDS INSTANCE
resource "aws_db_instance" "cv_first_postgres" {
  identifier = "terraform-postgres"

  engine         = "postgres"
  engine_version = "15"

  instance_class    = "db.t3.micro"
  allocated_storage = 20

  username = "admin_ved_03"
  password = "Vedpostgres03"

  db_subnet_group_name = aws_db_subnet_group.cv_first_postgres.name

  vpc_security_group_ids = [
    aws_security_group.cv_rds_security.id
  ]
  skip_final_snapshot = true
}

# RDS SECURITY GROUP
resource "aws_security_group" "cv_rds_security" {
  name   = "cv-rds-security"
  vpc_id = aws_vpc.cv_first_vpc.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.cv_ec2_security.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cv-rds-security"
  }
}