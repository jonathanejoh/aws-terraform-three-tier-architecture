# Create an EC2 Auto Scaling Group - web
resource "aws_autoscaling_group" "ejoh-three-tier-web-asg" {
  name                = "ejoh-three-tier-web-asg"
  launch_template     {id = aws_launch_template.ejoh-three-tier-web-lconfig.id }
  vpc_zone_identifier = [aws_subnet.ejoh-three-tier-pub-sub-1.id, aws_subnet.ejoh-three-tier-pub-sub-2.id]
  min_size            = 2
  max_size            = 3
  desired_capacity    = 2
  depends_on          = [aws_launch_template.ejoh-three-tier-web-lconfig]
}

# Create an EC2 Auto Scaling Group - app
resource "aws_autoscaling_group" "ejoh-three-tier-app-asg" {
  name                = "ejoh-three-tier-app-asg"
  launch_template     {id = aws_launch_template.ejoh-three-tier-app-lconfig.id}
  vpc_zone_identifier = [aws_subnet.ejoh-three-tier-pvt-sub-1.id, aws_subnet.ejoh-three-tier-pvt-sub-2.id]
  min_size            = 2
  max_size            = 3
  desired_capacity    = 2

  depends_on = [aws_launch_template.ejoh-three-tier-app-lconfig]
}

###################################################################################################################################


# Define a Launch Template for EC2 instances
resource "aws_launch_template" "ejoh-three-tier-web-lconfig" {
  name          = "wjoh-three-tier-web-lconfig"
  image_id      = "ami-0866a3c8686eaeeba"
  instance_type = "t2.micro"
  key_name      = "medium"
  user_data     = base64encode(file("${path.module}/ejohdata.sh"))


  # Attach security group to the instances
  network_interfaces {
    security_groups             = [aws_security_group.ejoh-three-tier-ec2-asg-sg.id]
    associate_public_ip_address = true
  }
  tags = {
  name = "ejoh-three-tier-web-ec2"
}
}



# Define a Launch Template for EC2 instances
resource "aws_launch_template" "ejoh-three-tier-app-lconfig" {
  name_prefix   = "ejoh-three-tier-app-lconfig"
  image_id      = "ami-0866a3c8686eaeeba"
  instance_type = "t2.micro"
  key_name      = "medium"
  user_data     = base64encode(file("${path.module}/ejohdata1.sh"))
  # Attach security group to the instances
  network_interfaces {
    security_groups             = [aws_security_group.ejoh-three-tier-ec2-asg-sg-app.id]
    associate_public_ip_address = false
  }
tags = {
  name = "ejoh-three-tier-app-ec2"
}
}

##########################################################
# Create a launch configuration for the EC2 instances
# resource "aws_launch_configuration" "ejoh-three-tier-app-lconfig" {
#   name_prefix     = "ejoh-three-tier-app-lconfig"
#   image_id        = "ami-0866a3c8686eaeeba"
#   instance_type   = "t2.micro"
#   key_name        = "medium"
#   security_groups = [aws_security_group.ejoh-three-tier-ec2-asg-sg-app.id]
#   user_data       = <<-EOF
#                                 #!/bin/bash

#                                 sudo yum install mysql -y

#                                 EOF

#   associate_public_ip_address = false
#   lifecycle {
#     prevent_destroy = false # change to true if in production
#     ignore_changes  = all
#   }
#   depends_on = [aws_security_group.ejoh-three-tier-ec2-asg-sg-app]
# }


# Create a launch configuration for the EC2 instances
# resource "aws_launch_configuration" "ejoh-three-tier-web-lconfig" {
#   name_prefix     = "ejoh-three-tier-web-lconfig"
#   image_id        = "ami-0866a3c8686eaeeba"
#   instance_type   = "t2.micro"
#   key_name        = "medium"
#   security_groups = [aws_security_group.ejoh-three-tier-ec2-asg-sg.id]
#   user_data     = base64encode(file("${path.module}/ejohdata.sh"))

#   associate_public_ip_address = true
#   lifecycle {
#     prevent_destroy = false # change to true if in production
#     ignore_changes  = all
#   }
#   depends_on = [aws_launch_configuration.ejoh-three-tier-web-lconfig]
# }

