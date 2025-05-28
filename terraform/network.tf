resource "aws_vpc" "cloud_storage_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
    tags = {
        Name = "cloud-storage-vpc"
        Environment = "Production"
    }
}

resource "aws_subnet" "private_subnet_a" {
  depends_on = [ aws_vpc.cloud_storage_vpc ]
  vpc_id            = aws_vpc.cloud_storage_vpc.id
  availability_zone = "us-east-1a" # Change to your preferred AZ
  cidr_block        = "10.0.4.0/24"
  tags = {
    Name = "private_subnet_a"
    Environment = "Production"
  }
}

resource "aws_subnet" "private_subnet_b" {
  depends_on = [ aws_vpc.cloud_storage_vpc ]
  vpc_id            = aws_vpc.cloud_storage_vpc.id
  availability_zone = "us-east-1b" # Change to your preferred AZ
  cidr_block        = "10.0.5.0/24"
  tags = {
    Name = "private_subnet_b"
    Environment = "Production"
  }
}

resource "aws_subnet" "public_subnet" {
  depends_on = [ aws_vpc.cloud_storage_vpc ]
  vpc_id            = aws_vpc.cloud_storage_vpc.id
  availability_zone = "us-east-1a" # Change to your preferred AZ
  cidr_block        = "10.0.6.0/24"
  map_public_ip_on_launch = true
    tags = {
        Name = "public_subnet"
        Environment = "Production"
    }
  
}

resource "aws_internet_gateway" "cloud_storage_igw" {
  depends_on = [ aws_vpc.cloud_storage_vpc ]
  vpc_id = aws_vpc.cloud_storage_vpc.id
  tags = {
    Name = "cloud-storage-igw"
    Environment = "Production"
  }
}

resource "aws_eip" "nat_eip" {
  # vpc = true
  domain = "vpc"
  tags = {
    Name = "cloud-storage-nat-eip"
    Environment = "Production"
  }
  
}

resource "aws_nat_gateway" "cloud_storage_nat" {
  depends_on = [ aws_eip.nat_eip, aws_subnet.public_subnet ]
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = "cloud-storage-nat-gateway"
    Environment = "Production"
  }
  
}

resource "aws_route_table" "private_route_table" {
  depends_on = [ aws_vpc.cloud_storage_vpc, aws_nat_gateway.cloud_storage_nat ]
    vpc_id = aws_vpc.cloud_storage_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.cloud_storage_nat.id
    }
    tags = {
        Name = "private_route_table"
        Environment = "Production"
    }
}

resource "aws_route_table" "public_route_table" {
  depends_on = [ aws_vpc.cloud_storage_vpc, aws_internet_gateway.cloud_storage_igw ]
    vpc_id = aws_vpc.cloud_storage_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.cloud_storage_igw.id
    }  
    tags = {
        Name = "public_route_table"
        Environment = "Production"
    }
}

resource "aws_route_table_association" "private_route_table_association_a" {
  depends_on = [ aws_subnet.private_subnet_a, aws_route_table.private_route_table ]
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_route_table.id
}
resource "aws_route_table_association" "private_route_table_association_b" { 
  depends_on = [ aws_subnet.private_subnet_b, aws_route_table.private_route_table ]
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "public_route_table_association" {
  depends_on = [ aws_subnet.public_subnet, aws_route_table.public_route_table ]
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}