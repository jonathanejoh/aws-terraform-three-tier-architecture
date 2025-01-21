#### RDS ####
resource "aws_db_subnet_group" "ejoh-3tier-db-sub-grp" {
  name       = "ejoh-3tier-db-sub-grp"
  subnet_ids = ["${aws_subnet.ejoh-three-tier-pvt-sub-3.id}", "${aws_subnet.ejoh-three-tier-pvt-sub-4.id}"]
}



resource "aws_db_instance" "ejoh-three-tier-db" {
  allocated_storage      = 100
  storage_type           = "gp3"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  identifier             = "ejoh-three-tier-db"
  username               = "admin"
  password               = "password"
  parameter_group_name   = "default.mysql8.0"
  db_subnet_group_name   = aws_db_subnet_group.ejoh-3tier-db-sub-grp.name
  vpc_security_group_ids = ["${aws_security_group.ejoh-three-tier-db-sg.id}"]
  multi_az            = true
  skip_final_snapshot = true
  publicly_accessible = false
  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
  depends_on = [aws_db_subnet_group.ejoh-3tier-db-sub-grp,
    aws_security_group.ejoh-three-tier-db-sg

  ]
}