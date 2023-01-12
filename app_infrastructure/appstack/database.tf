resource "aws_security_group" "b2c_rds_inbound" {
  name = "b2c_rds_inbound_${var.feature}"
  vpc_id = data.aws_vpc.b2c_vpc.id
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0 
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "b2c_rds_inbound_${var.feature}"
  }
}

resource "aws_db_subnet_group" "b2c_subnet_group" {
  name = "b2c_subnet_group"
  subnet_ids = [data.aws_subnet.private_1.id, data.aws_subnet.private_2.id, data.aws_subnet.private_3.id]
  tags = {
    Name = "b2c_subnet_group"
  }
}

resource "aws_rds_cluster" "b2c_rds_cluster_clone" {
  cluster_identifier = "b2c-rds-cluster-${var.feature}"
  engine = "aurora-mysql"
  engine_mode = "provisioned"
  engine_version = "8.0.mysql_aurora.3.02.0"
  #database_name = "b2c"
  #master_username = "admin"
  #master_password = "wochild1"
  db_subnet_group_name = aws_db_subnet_group.b2c_subnet_group.id
  vpc_security_group_ids = [aws_security_group.b2c_rds_inbound.id]
  skip_final_snapshot = true

  serverlessv2_scaling_configuration {
    max_capacity = 1.0
    min_capacity = 0.5
  }

  restore_to_point_in_time {
    source_cluster_identifier = "arn:aws:rds:us-west-2:705740530616:cluster:b2c-rds-cluster"
    restore_type = "copy-on-write"
    use_latest_restorable_time = true
  }
}

#resource "aws_rds_cluster_instance" "b2c_rds_instance" {
#  cluster_identifier = aws_rds_cluster_clone.b2c_rds_cluster.id
#  instance_class = "db.serverless"
#  engine = aws_rds_cluster.b2c_rds_cluster.engine
#  engine_version = aws_rds_cluster.b2c_rds_cluster.engine_version
#  db_subnet_group_name = aws_rds_cluster.b2c_rds_cluster.db_subnet_group_name
#}
