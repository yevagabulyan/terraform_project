# Auto Scaling Group

resource "aws_autoscaling_group" "my_asg" {
  desired_capacity    = 2
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = [var.public_subnet_id, var.public_subnet1_id]
  target_group_arns = [var.target_group_arn]
  launch_template {
    id      = aws_launch_template.asg.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "my-asg-instance"
    propagate_at_launch = true
  }

  health_check_type         = "ELB"
  health_check_grace_period = 50

}

# Launch Template
resource "aws_launch_template" "asg" {
  name_prefix            = "asg-lt-"
  image_id               = var.ami_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [var.instance_sg_id]
  lifecycle {
    create_before_destroy = true
  }
  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Hello to my Master < $(hostname -f)" > /var/www/html/index.html
              EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "asg-instance"
    }
  }
}
