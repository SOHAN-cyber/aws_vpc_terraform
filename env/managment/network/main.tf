resource "aws_vpc" "my-vpc" {
  cidr_block         = var.cidr_block
  enable_dns_support = var.enable_dns_support
  instance_tenancy   = "default"
  tags = {
    Name = "devops-training-vpc"
  }
}

resource "aws_internet_gateway" "my-gateway" {
  vpc_id = aws_vpc.my-vpc.id 

  tags = {
    Name = "my-gateway"
    Env = "Devops"
  }
}

resource "aws_s3_bucket" "vpc-flow-log-bucket" {
  bucket = "devops-flow-logs-bucket"

  tags = {
    Name        = "flow_log_bucket"
    Environment = "devops"
  }
}

resource "aws_flow_log" "my_vpc_flow_log" {
  traffic_type             = "ALL"
  log_destination_type     = "s3"
  log_destination          = aws_s3_bucket.vpc-flow-log-bucket.arn
  vpc_id                   = aws_vpc.my-vpc.id
  max_aggregation_interval = 60
  depends_on = [
    aws_s3_bucket.vpc-flow-log-bucket
  ]
  tags = {
    Name        = "devops_vpc_flow_logs"
    Environment = "devops"
  }
}


resource "aws_subnet" "public_subnet" {
  count                   = var.create_public_subnet ? length(var.public_cidr_block) : 0
  vpc_id                  = aws_vpc.my-vpc.id
  availability_zone       = element(var.availability_zone, count.index)
  cidr_block              = element(var.public_cidr_block, count.index)
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags = {
    Name = "public-subnet-${count.index + 1}"
    Env  = "devops"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-gateway.id
  }

  tags = {
    "Name" = "devops-pb-rt"
  }
}

resource "aws_route_table_association" "rt-route" {
  count = length(aws_subnet.public_subnet.*.id)
  route_table_id = aws_route_table.public-route-table.id
  subnet_id = element(aws_subnet.public_subnet.*.id, count.index)
}

resource "aws_subnet" "private_subnet" {
  count             = var.create_private_subnet ? length(var.private_cidr_block) : 0
  vpc_id            = aws_vpc.my-vpc.id
  availability_zone = element(var.availability_zone, count.index)
  cidr_block        = element(var.private_cidr_block, count.index)
  tags = {
    Name = "private-subnet-${count.index + 1}"
    Env  = "devops"
  }
}

resource "aws_eip" "elastic_ip" {
  vpc = true
  tags = {
    Name = "nat-gateway-ip"
    Env = "Devops"
  }
}

  resource "aws_nat_gateway" "my-nat" {         
    allocation_id = aws_eip.elastic_ip.id
    subnet_id = aws_subnet.public_subnet[0].id
    connectivity_type = "public"
    tags = {
      Name = "my-nat"
    }
  }

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.my-nat.id
  }

  tags = {
    "Name" = "devops-pv-rt"
  }
}

resource "aws_route_table_association" "private-route" {
  count = length(aws_subnet.private_subnet.*.id)
  route_table_id = aws_route_table.private-route-table.id
  subnet_id = element(aws_subnet.private_subnet.*.id, count.index)
}