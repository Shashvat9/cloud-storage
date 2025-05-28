resource "aws_db_subnet_group" "cloud_storage_db_subnet_group" {
  depends_on = [ aws_subnet.private_subnet_a, aws_subnet.private_subnet_b ]
  name       = "cloud-storage-db-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_a.id,aws_subnet.private_subnet_b.id]

  tags = {
    Name        = "Cloud Storage DB Subnet Group"
    Environment = "Production"
  }
  
}


resource "aws_db_instance" "cloud_storage_db" {

  depends_on              = [aws_db_subnet_group.cloud_storage_db_subnet_group, aws_vpc.cloud_storage_vpc]
  
  identifier              = "cloud-storage-db"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp2"
  username                = var.DB_username
  password                = var.DB_password 
  db_name                 = "cloud_storage_db"
  skip_final_snapshot     = true
  publicly_accessible     = false
  db_subnet_group_name    = aws_db_subnet_group.cloud_storage_db_subnet_group.name
  vpc_security_group_ids = [ aws_security_group.db_security_group.id ] # Replace with your actual security group ID
  multi_az                = false
  
  tags = {
    Name        = "Cloud Storage Database"
    Environment = "Production"
  }
  
}